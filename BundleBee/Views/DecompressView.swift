//
//  DecompressView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct DecompressView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var archiveManager = ArchiveManager()
    @State private var showingExtractionOptions = false // TODO: Verificar se essa variável realmente está sendo usada
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Decompress Archive",subtitle: "Drag and drop a compressed archive to extract it")
            
            if let archive = archiveManager.selectedArchive {
                ScrollView {
                    VStack(spacing: 16) {
                        GroupBox {
                            VStack(alignment: .leading, spacing: 12) {
                                selectedArchiveHeaderView
                               
                                Divider()
                                
                                fileRowView(file: archive)
                                    .padding(8)
                                    .background(Color(nsColor: .controlBackgroundColor))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(4)
                        }
                        
                        extractionDestinationView
                        extractButtonView(file: archive)
                    }
                    .padding(.horizontal, 16)
                }
            } else {
                VStack(spacing: 24) {
                    DropZoneView(archiveManager: archiveManager)
                    .padding(.horizontal, 16)
                    .environmentObject(appState)
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .openArchiveFile)) { notification in
            appState.isDecompression = true
            if let archive = notification.object as? URL {
                archiveManager.handleSelectedFiles(Array(arrayLiteral: archive))
                showingExtractionOptions = true
            }
        }
        .onAppear {
            appState.isDecompression = true
            if let pending = appState.pendingArchiveToOpen {
                archiveManager.handleSelectedFiles(Array(arrayLiteral: pending))
                showingExtractionOptions = true
            }
        }
    }
    
    var selectedArchiveHeaderView: some View {
        Label("Selected Archive", systemImage: "archivebox.fill")
            .font(.headline)
    }
    
    func fileRowView(file archive: URL) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "doc.zipper")
                .font(.system(size: 40))
                .foregroundStyle(.blue)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(archive.lastPathComponent)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(archive.deletingLastPathComponent().path)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                
                if let fileSize = try? FileManager.default.attributesOfItem(atPath: archive.path)[.size] as? Int64 {
                    Text(ByteCountFormatter.string(fromByteCount: fileSize, countStyle: .file))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            
            Spacer()
            
            Button {
                archiveManager.selectedArchive = nil
                showingExtractionOptions = false
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
    }
    
    var extractionDestinationView: some View {
        GroupBox {
            VStack(alignment: .leading, spacing: 12) {
                Label("Extraction Destination", systemImage: "folder.fill")
                    .font(.headline)
                
                HStack {
                    Text("Same folder as de file")
                        .font(.subheadline)
                    
                    Spacer()
                    
                    Button("Choose Folder...") {
                        // TODO: Implement folder picker (Passo 4)
                    }
                    .buttonStyle(.bordered)
                    .controlSize(.small)
                }
            }
            .padding(4)
        }
    }
    
    func extractButtonView(file archive: URL) -> some View {
        HStack(spacing: 12) {
            Button("Cancel") {
                archiveManager.selectedArchive = nil
                showingExtractionOptions = false
            }
            .buttonStyle(.bordered)
            
            Spacer()
            
            Button("Extract") {
                // TODO: Implement extraction (Passo 4)
                print("Extract: \(archive.lastPathComponent)")
            }
            .buttonStyle(.borderedProminent)
        }
    }
}
