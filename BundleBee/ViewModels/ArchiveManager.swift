//
//  DropZoneViewModel.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 18/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

class ArchiveManager: ObservableObject {
    @EnvironmentObject private var appState: AppState
    @Published var selectedFiles: [URL] = []
    @Published var selectedArchive: URL?
    
    func handleDrop(providers: [NSItemProvider], onFilesSelected: (([URL]) -> Void)?) -> Bool {
        var urls: [URL] = []
        let group = DispatchGroup()
        
        for provider in providers {
            group.enter()
            _ = provider.loadObject(ofClass: URL.self) { [weak self] url, error in
                defer { group.leave() }
                
                guard let self else { return }
                
                if let url {
                    if self.appState.isDecompression {
                        if isArchiveFile(url) {
                            urls.append(url)
                        }
                    } else {
                        urls.append(url)
                    }
                }
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self else { return }
            
            if !urls.isEmpty {
                if self.appState.isDecompression {
                    onFilesSelected?([urls.first!])
                } else {
                    self.selectedFiles.append(contentsOf: urls)
                    onFilesSelected?(urls)
                }
            }
        }
        
        return true
    }
    
    func selectFiles(allowMultiple: Bool, onFilesSelected: (([URL]) -> Void)?) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = allowMultiple
        panel.canChooseDirectories = !appState.isDecompression
        panel.canChooseFiles = true
        
        if appState.isDecompression {
            panel.allowedContentTypes = [
                .zip, .gzip,
                UTType(filenameExtension: "rar") ?? .data,
                UTType(filenameExtension: "7z") ?? .data,
                UTType(filenameExtension: "tar") ?? .data,
                UTType(filenameExtension: "tar.gz") ?? .data
            ]
        }
        
        panel.begin { [weak self] response in
            guard let self else { return }
            
            if response == .OK {
                let urls = panel.urls
                if self.appState.isDecompression {
                    onFilesSelected?(urls)
                } else {
                    self.selectedFiles.append(contentsOf: urls)
                    onFilesSelected?(urls)
                }
            }
        }
    }
    
    private func isArchiveFile(_ url: URL) -> Bool {
        let archiveExtensions = ["zip", "gzip", "rar", "7z", "tar", "tar.gz"]
        let ext = url.pathExtension.lowercased()
        return archiveExtensions.contains(ext)
    }
    
    
}
