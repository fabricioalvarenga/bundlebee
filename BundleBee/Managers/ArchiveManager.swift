//
//  ArchiveManager.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 31/12/25.
//

import AppKit

// TODO: Trabalhar com arquivos protegidos por senha e implementar barra de progresso
// TODO: Tratar sobre a compactação/descompactação assíncrona com "Task.detached"
// TODO: Mostrar barra de progresso na compactação/descompactação
// TODO: Ao selecionar o arquivo para descompressão ou o primeiro arquivo para compressão,
//       verificar se é possível adicionar a pasta dele no "security bookmark" e,
//       se sim, ela deve ser a "destionation folder" caso o usuário ainda não tenho escolhido nenhuma
class ArchiveManager {
    static let shared = ArchiveManager()
    
    private init() {}
    
    func createArchive(
        from sourceURLs: [URL],
        to destinationURL: URL? = nil,
        format: CompressionFormat,
        password: String? = nil,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> URL? {
        guard let destination = destinationURL else { throw ArchiveError.invalidDestinationFolder }
        
        let sandboxAccess = destination.startAccessingSecurityScopedResource()
        if !sandboxAccess { throw ArchiveError.accessDeniedToFolder(destination.path(percentEncoded: false)) }
        defer {
            if sandboxAccess {
                destination.stopAccessingSecurityScopedResource()
            }
        }
        
        // TODO: Necessário dar opção para o usuário escolher o nome do arquivo e
        //       colocar automaticamente a extensão de acordo com o tipo de compressão escolhida
        //       E caso o usuário escolha um nome de arquivo já existente, necessário dar
        //       opção para que ele decida se vai apenas atualizar o arquivo (o processo 'zip', por exemplo, permite isso)
        //       ou se vai criar um novo
        // Add a suffix to archive name if it already exists
        let archiveName = "bundlebee_archive"
        let compressionURL = addSuffix(to: destination.appending(path: archiveName), archiveExtension: "zip")
        
        let success = zipUsingProcess(from: sourceURLs, to: compressionURL)
        
        guard success else { throw ArchiveError.extractionFailed }
            
        return await MainActor.run { compressionURL }
    }
    
    func extractArchive(
        from sourceURL: URL,
        to destinationURL: URL? = nil,
        password: String? = nil,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> URL {
        guard let destination = destinationURL else { throw ArchiveError.invalidDestinationFolder }
        
        let sandboxAccess = destination.startAccessingSecurityScopedResource()
        if !sandboxAccess { throw ArchiveError.accessDeniedToFolder(destination.path(percentEncoded: false)) }
        defer {
            if sandboxAccess {
                destination.stopAccessingSecurityScopedResource()
            }
        }
        
        // Add a suffix to folder name if it already exists
        let archiveName = sourceURL.deletingPathExtension().lastPathComponent
        let extractionURL = addSuffix(to: destination.appending(path: archiveName))
        
        do {
            try FileManager.default.createDirectory(at: extractionURL, withIntermediateDirectories: true)
        } catch {
            throw ArchiveError.cannotCreateFolder(extractionURL.path(percentEncoded: false))
        }
        
        let success = unzipUsingProcess(sourceURL: sourceURL, destinationURL: extractionURL)
        
        guard success else { throw ArchiveError.extractionFailed }
            
        return await MainActor.run { extractionURL }
    }
    
    // TODO: Trabalhar com arquivos protegidos por senha e implementar barra de progresso
    // TODO: Tratar sobre a compactação assíncrona com "Task.detached"
    // TODO: Trabalhar com diferentes modos de compressão (opções -1 e -9 do zip)
    private func zipUsingProcess(
        from sourceURLs: [URL],
        to destinationURL: URL,
        password: String? = nil,
        compressionLevel: CompressionMode = .normal,
        progressHandler: ((Double) -> Void)? = nil
    ) -> Bool {
        // TODO: Necessário dar opção para o usuário escolher o nome do arquivo e colocar automaticamente a extensão de acordo com o tipo de compressão escolhida
        let destination = destinationURL
        
        var arguments = ["-q"] // Quiet mode
        arguments.append("-r") // Recursion

        if let pwd = password, !pwd.isEmpty {
            arguments.append(contentsOf: ["-P", pwd])
        }
       
        arguments.append(destination.path)
        arguments.append(contentsOf: sourceURLs.map { $0.path(percentEncoded: false) })
        
        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/zip")
        process.arguments = arguments
        
        let status = executeProcess(process)
        return status
    }

    private func unzipUsingProcess(
        sourceURL: URL,
        destinationURL: URL,
        password: String? = nil,
        progressHandler: ((Double) -> Void)? = nil
    ) -> Bool {
        var arguments = ["-o"] // Overwrite if necessary
        arguments.append("-q") // Quiet mode
        
        if let pwd = password, !pwd.isEmpty {
            arguments.append(contentsOf: ["-P", pwd])
        }
        
        arguments.append(sourceURL.path)
        arguments.append("-d")
        arguments.append(destinationURL.path)
        
        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/unzip")
        process.arguments = arguments
        
        let status = executeProcess(process)
        return status
    }
    
    // Add a suffix to folder/archive name if it already exists
    private func addSuffix(to url: URL, archiveExtension: String? = nil) -> URL {
        let archiveName = url.lastPathComponent
        var result = url
        for count in 2..<100 {
            if let archiveExtension {
                result = result.appendingPathExtension(archiveExtension)
            }
            
            if FileManager.default.fileExists(atPath: result.path(percentEncoded: false)) {
                result = url.deletingLastPathComponent()
                result = result.appending(path: "\(archiveName) [\(count)]")
                continue
            }
            break
        }
        return result
    }
    
    private func executeProcess(_ process: Process) -> Bool {
        do {
            try process.run()
            process.waitUntilExit()
            
            let status = process.terminationStatus
            return status == 0
        } catch {
            // TODO: Tratar erro. Talvez marcar a função com "throws"
            print("Erro ao executar: \(error)")
            return false
        }
    }
    
    func selectDestinationFolder() -> URL? {
        let panel = NSOpenPanel()
        
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        
        let response = panel.runModal()
        
        if response == .OK, let url  = panel.url {
            saveBookmark(for: url)
            return url
        }
        
        return nil
    }
 
    private func saveBookmark(for url: URL) {
        guard let bookmarkData = try? url.bookmarkData(options: .withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil) else {
            return
        }
        
        var bookmarks = loadBookmarks()
        
        let bookmark = FolderBookmark(id: url, data: bookmarkData)
        bookmarks.removeAll { $0.id == url }
        bookmarks.append(bookmark)
        
        let encoded = try? JSONEncoder().encode(bookmarks)
        UserDefaults.standard.set(encoded, forKey: FolderBookmark.key)
    }
    
    private func loadBookmarks() -> [FolderBookmark] {
        guard let data = UserDefaults.standard.data(forKey: FolderBookmark.key) else {
            return []
        }
        
        let decode =  (try? JSONDecoder().decode([FolderBookmark].self, from: data)) ?? []
        return decode
    }
    
    private func loadBookmark(for url: URL) -> FolderBookmark? {
        loadBookmarks().first(where: { $0.id == url })
    }
     
    private func resolveBookmark(_ bookmark: FolderBookmark) throws -> URL {
        var isStale = true
        
        let url = try? URL(resolvingBookmarkData: bookmark.data, options: .withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        
        guard let url, !isStale else {
            throw ArchiveError.accessDeniedToFolder(bookmark.id.path(percentEncoded: false))
        }
        
        return url
    }
}
