//
//  DropZoneViewModel.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 18/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

class FileService: ObservableObject {
    @Published var selectedFiles: [URL] = []
    @Published var selectedArchive: URL?
    @Published var selectedCompressionFormat: CompressionFormat = .zip
    @Published var selectedCompressionMode: CompressionMode = .fast
    @Published var compressionDestinationFolder = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first
    @Published var decompressionDestinationFolder = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first
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
        
        let response = panel.runModal()
        
        if response == .OK {
            self.handleSelectedFiles(panel.urls)
        }
    }
    
    func selectDestinationFolder() {
        let panel = NSOpenPanel()
        
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.canCreateDirectories = true
        
        let response = panel.runModal()
        
        let folder: URL?
        
        if response == .OK {
            folder = panel.url
        } else {
            folder = FileManager.default.urls(for: .documentationDirectory, in: .userDomainMask).first
        }
        
        if appState.isDecompression {
            decompressionDestinationFolder = folder
        } else {
            compressionDestinationFolder = folder
        }
    }
    
    func handleSelectedFiles(_ urls: [URL]) {
        if !urls.isEmpty {
            appState.pendingArchiveToOpen = nil
            appState.pendingFilesToCompress?.removeAll()
            
            if appState.isDecompression {
                selectedArchive = urls.filter { isArchiveFile($0) }.first
            } else {
                // Filters out all existing files in 'selectedFiles' so that they are not selected more than once.
                let filteredUrls = urls.filter { !selectedFiles.contains($0) }
                selectedFiles.append(contentsOf: filteredUrls)
            }
        }
    }
    
    func compress() {
    }
    
    func extract() {
    }
    
    private func isArchiveFile(_ url: URL) -> Bool {
        let archiveExtensions = CompressionFormat.archiveExtensions
        let ext = url.pathExtension.capitalized
        return archiveExtensions.contains(ext)
    }
}
