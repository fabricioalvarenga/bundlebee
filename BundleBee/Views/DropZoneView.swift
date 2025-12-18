//
//  DropZoneView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct DropZoneView: View {
    @EnvironmentObject var appState: AppState
    @ObservedObject var archiveManager: ArchiveManager
    var isDecompression: Bool = false
    var onFilesSelected: (([URL]) -> Void)?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 20) {
                Image(systemName: appState.isDragging ? "arrow.down.circle.fill" : "arrow.down.doc.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(appState.isDragging ? .blue : .secondary)
                    .symbolEffect(.bounce, value: appState.isDragging)
                
                VStack(spacing: 8) {
                    Text(appState.isDragging ? "Drop the files here" : "Drag the files here")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text(isDecompression ? "or click the \"Select Archive\" button below" : "or click the \"Select Files\" button bellow")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if isDecompression {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Suported Formats", systemImage: "info.circle")
                                .font(.headline)
                            
                            Text("ZIP • GZIP • RAR • 7Z • TAR • TAR.GZ")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(4)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        appState.isDragging ? Color.accentColor : Color.secondary.opacity(0.3),
                        style: StrokeStyle(lineWidth: 2, dash: [10, 5])
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(appState.isDragging ? Color.accentColor.opacity(0.05) : Color.clear)
                    )
            )
            
            Button(isDecompression ? "Select Archive" : "Select Files") {
                selectFiles(allowMultiple: !isDecompression)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding(.top, 8)
            
        }
        .padding(.bottom, 16)
        .onDrop(of: [.fileURL], isTargeted: $appState.isDragging) { providers in
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
                    archiveManager.selectedFiles.append(contentsOf: urls)
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
                    archiveManager.selectedFiles.append(contentsOf: urls)
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
