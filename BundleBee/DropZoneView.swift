//
//  DropZoneView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DropZoneView: View {
    @Binding var isDragging: Bool
    @Binding var selectedFiles: [URL]
    var isDecompression: Bool = false
    var onFilesSelected: (([URL]) -> Void)?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: isDragging ? "arrow.down.circle.fill" : "arrow.down.doc.fill")
                .font(.system(size: 64))
                .foregroundStyle(isDragging ? .blue : .secondary)
                .symbolEffect(.bounce, value: isDragging)
            
            VStack(spacing: 8) {
                Text(isDragging ? "Drop the files here" : "Drag the files here")
                    .font(.title3)
                    .fontWeight(.medium)
                
                Text(isDecompression ? "or click to select a compressed archive" : "or click to select files")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            Button(isDecompression ? "Select Archive" : "Select Files") {
                selectFiles(allowMultiple: !isDecompression)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
        .frame(maxWidth: .infinity)
        .padding(60)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(
                    isDragging ? Color.accentColor : Color.secondary.opacity(0.3),
                    style: StrokeStyle(lineWidth: 2, dash: [10, 5])
                )
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(isDragging ? Color.accentColor.opacity(0.05) : Color.clear)
                )
        )
        .onDrop(of: [.fileURL], isTargeted: $isDragging) { providers in
            handleDrop(providers: providers)
        }
    }
    
    private func handleDrop(providers: [NSItemProvider]) -> Bool {
        var urls: [URL] = []
        let group = DispatchGroup()
        
        for provider in providers {
            group.enter()
            _ = provider.loadObject(ofClass: URL.self) { url, error in
                defer { group.leave() }
                
                if let url = url {
                    if isDecompression {
                        if isArchiveFile(url) {
                            urls.append(url)
                        }
                    } else {
                        urls.append(url)
                    }
                }
            }
        }
        
        group.notify(queue: .main) {
            if !urls.isEmpty {
                if isDecompression {
                    onFilesSelected?([urls.first!])
                } else {
                    selectedFiles.append(contentsOf: urls)
                    onFilesSelected?(urls)
                }
            }
        }
        
        return true
    }
    
    private func selectFiles(allowMultiple: Bool) {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = allowMultiple
        panel.canChooseDirectories = !isDecompression
        panel.canChooseFiles = true
        
        if isDecompression {
            panel.allowedContentTypes = [
                .zip, .gzip,
                UTType(filenameExtension: "rar") ?? .data,
                UTType(filenameExtension: "7z") ?? .data,
                UTType(filenameExtension: "tar") ?? .data,
                UTType(filenameExtension: "tar.gz") ?? .data
            ]
        }
        
        panel.begin { response in
            if response == .OK {
                let urls = panel.urls
                if isDecompression {
                    onFilesSelected?(urls)
                } else {
                    selectedFiles.append(contentsOf: urls)
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
