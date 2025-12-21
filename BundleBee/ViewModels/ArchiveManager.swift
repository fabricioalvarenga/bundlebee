//
//  DropZoneViewModel.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 18/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

class ArchiveManager: ObservableObject {
    @Published var selectedFiles: [URL] = []
    @Published var selectedArchive: URL?
    private var appState = AppState.shared
    
    func handleDrop(providers: [NSItemProvider]) -> Bool {
        var urls: [URL] = []
        let group = DispatchGroup()
        
        for provider in providers {
            group.enter()
            
            _ = provider.loadObject(ofClass: URL.self) { url, error in
                defer { group.leave() }
                guard let url else { return }
                urls.append(url)
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            self.handleSelectedFiles(urls)
        }
        
        return true
    }
    
    func selectFiles() {
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = !appState.isDecompression
        panel.canChooseDirectories = !appState.isDecompression
        panel.canChooseFiles = true
        
        if appState.isDecompression {
            panel.allowedContentTypes = [
                .zip, .gzip, .tarArchive, .bz2,
                UTType(filenameExtension: "rar") ?? .data,
                UTType(filenameExtension: "7z") ?? .data,
                UTType(filenameExtension: "tgz") ?? .data
            ]
        }
        
        panel.begin { [weak self] response in // TODO: Fazer esse painel aparecer como "modal"
            guard let self else { return }
            
            if response == .OK {
                self.handleSelectedFiles(panel.urls)
            }
        }
    }
    
    func handleSelectedFiles(_ urls: [URL]) {
        if !urls.isEmpty {
            appState.pendingArchiveToOpen = nil
            appState.pendingFilesToCompress?.removeAll()
            selectedFiles = urls
            
            if appState.isDecompression {
                selectedArchive = urls.filter { isArchiveFile($0) }.first
                selectedFiles.removeAll()
            } else {
                selectedArchive = nil
                selectedFiles = urls
            }
        }
    }
    
    private func isArchiveFile(_ url: URL) -> Bool {
        let archiveExtensions = CompressionFormat.archiveExtensions
        let ext = url.pathExtension.lowercased()
        return archiveExtensions.contains(ext)
    }
}
