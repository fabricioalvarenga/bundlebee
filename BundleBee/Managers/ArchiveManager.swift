//
//  ArchiveManager.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 31/12/25.
//

import AppKit

class ArchiveManager {
    static let shared = ArchiveManager()
    
    private init() {}
    
    func extractArchive(
        from sourceURL: URL,
        to destinationURL: URL? = nil,
        password: String? = nil,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> URL {
        let archiveName = sourceURL.deletingPathExtension().lastPathComponent
        
        // Sandbox access
        let baseURL = try {
            let initialURL = destinationURL ?? sourceURL.deletingLastPathComponent()
            if let bookmark = loadBookmark(for: initialURL) {
                return try resolveBookmark(bookmark)
            }
            return initialURL
        }()
        
        
        let sandboxAccess = baseURL.startAccessingSecurityScopedResource()
        if !sandboxAccess { throw ArchiveError.accessDeniedToFolder(baseURL.path(percentEncoded: false)) }
        defer {
            if sandboxAccess {
                baseURL.stopAccessingSecurityScopedResource()
            }
        }
        
        // Try creating a folder that doesn't already exist, with a suffix ranging from 2 to 99.
        var destination = baseURL.appending(path: archiveName)
        for count in 2..<100 {
            if FileManager.default.fileExists(atPath: destination.path) {
                destination = baseURL.appending(path: "\(archiveName) [\(count)]")
                continue
            }
            break
        }
           
        do {
            try FileManager.default.createDirectory(at: destination, withIntermediateDirectories: true)
        } catch (let error) {
            print(error.localizedDescription)
            throw ArchiveError.cannotCreateFolder(destination.path(percentEncoded: false))
        }
        
        let success = self.unzipUsingProcess(
            sourceURL: sourceURL,
            destinationURL: destination,
            password: password,
            progressHandler: progressHandler
        )
        
        guard success else { throw ArchiveError.extractionFailed }
            
        let finalDestination = destination
        return await MainActor.run { finalDestination }
    }
    
    private func unzipUsingProcess(
        sourceURL: URL,
        destinationURL: URL,
        password: String?,
        progressHandler: ((Double) -> Void)?
    ) -> Bool {
        let process = Process()
        process.executableURL = URL(filePath: "/usr/bin/unzip")
        
        var arguments = ["-o"] // Overwrite if necessary
        
        if let pwd = password, !pwd.isEmpty {
            arguments.append(contentsOf: ["-P", pwd])
        }
        
        arguments.append("-q") // Quiet mode
        arguments.append(sourceURL.path)
        arguments.append("-d")
        arguments.append(destinationURL.path)
        
        process.arguments = arguments
        
        do {
            try process.run()
            process.waitUntilExit()
            let status = process.terminationStatus
            
            print(arguments)
            print(status)
            
            return status == 0
        } catch {
            // TODO: Tratar erro. Talvez marcar a função com "throws"
            print("Erro ao executar unzip: \(error)")
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
