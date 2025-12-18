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
    var appState: AppState? = nil
    
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
        guard let appState else { return }
        
        let panel = NSOpenPanel()
        
        panel.allowsMultipleSelection = !appState.isDecompression
        panel.canChooseDirectories = !appState.isDecompression
        panel.canChooseFiles = true
        
        if appState.isDecompression {
            panel.allowedContentTypes = [
                .zip, .gzip, .tarArchive,
                UTType(filenameExtension: "rar") ?? .data,
                UTType(filenameExtension: "7z") ?? .data,
                UTType(filenameExtension: "tgz") ?? .data
            ]
        }
        
        panel.begin { [weak self] response in
            guard let self else { return }
            
            if response == .OK {
                self.handleSelectedFiles(panel.urls)
            }
        }
    }
    
    private func handleSelectedFiles(_ urls: [URL]) {
        guard let appState else { return }
        
        if !urls.isEmpty {
            selectedFiles = urls
            if appState.isDecompression {
                selectedArchive = selectedFiles.filter { isArchiveFile($0) }.first
            }
        }
    }
    
    private func isArchiveFile(_ url: URL) -> Bool {
        let archiveExtensions = ["zip", "gzip", "rar", "7z", "tar", "tgz"]
        let ext = url.pathExtension.lowercased()
        return archiveExtensions.contains(ext)
    }
}
