//
//  DecompressView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct DecompressView: View {
    @EnvironmentObject var appState: AppState
    @StateObject private var archiveManager = ArchiveManager()
    @State private var showingExtractionOptions = false
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Decompress Archive",subtitle: "Drag and drop a compressed archive to extract it")
            
            Divider()
                .padding(.vertical, 16)
            
            if let archive = archiveManager.selectedArchive {
                ScrollView {
                    VStack(spacing: 16) {
                        GroupBox {
                            VStack(alignment: .leading, spacing: 12) {
                                Label("Selected Archive", systemImage: "archivebox.fill")
                                    .font(.headline)
                                
                                Divider()
                                
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
                                .padding(8)
                                .background(Color(nsColor: .controlBackgroundColor))
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            .padding(4)
                        }
                        
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
                    .padding(.horizontal, 32)
                }
            } else {
                VStack(spacing: 24) {
                    DropZoneView(
                        archiveManager: archiveManager,
                        isDecompression: true,
                        onFilesSelected: { urls in
                            if let url = urls.first {
                                archiveManager.selectedArchive = url
                                showingExtractionOptions = true
                                print("Selected archive: \(url.lastPathComponent)")
                            }
                        }
                    )
                    .padding(.horizontal, 16)
                    .environmentObject(appState)
                }
            }
        }
    }
}
