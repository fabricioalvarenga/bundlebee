//
//  CompressView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct CompressView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var archiveManager = ArchiveManager()
    @State private var compressionFormat: CompressionFormat = .zip
    @State private var usePassword = false
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 0) {
            HeaderView(title: "Compress Files", subtitle: "Add files to create a compressed archive")
            
            Divider()
                .padding(.vertical, 16)
            
            VStack(spacing: 24) {
                if archiveManager.selectedFiles.isEmpty {
                    DropZoneView(archiveManager: archiveManager)
                    .padding(.horizontal, 16)
                    .environmentObject(appState)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            GroupBox {
                                VStack(alignment: .leading, spacing: 12) {
                                    Label("Compression Format", systemImage: "archivebox")
                                        .font(.headline)
                                    
                                    Picker("", selection: $compressionFormat) {
                                        ForEach(CompressionFormat.allCases, id: \.self) { format in
                                            Text(format.rawValue).tag(format)
                                        }
                                    }
                                    .pickerStyle(.segmented)
                                }
                                .padding(4)
                            }
                            
                            GroupBox {
                                VStack(alignment: .leading, spacing: 12) {
                                    Toggle(isOn: $usePassword) {
                                        Label("Protect with password", systemImage: "lock.fill")
                                            .font(.headline)
                                    }
                                    
                                    if usePassword {
                                        SecureField("Enter the password", text: $password)
                                            .textFieldStyle(.roundedBorder)
                                    }
                                }
                                .padding(4)
                            }
                            
                            GroupBox {
                                VStack(alignment: .leading, spacing: 8) {
                                    HStack {
                                        Label("Selected Files", systemImage: "doc.fill")
                                            .font(.headline)
                                        Spacer()
                                        Text("\(archiveManager.selectedFiles.count)")
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.accentColor.opacity(0.2))
                                            .clipShape(Capsule())
                                    }
                                    
                                    Divider()
                                    
                                    ForEach(archiveManager.selectedFiles, id: \.self) { file in
                                        FileRowView(url: file) {
                                            archiveManager.selectedFiles.removeAll { $0 == file }
                                        }
                                    }
                                }
                                .padding(4)
                            }
                            
                            HStack(spacing: 12) {
                                Button("Clean") {
                                    archiveManager.selectedFiles.removeAll()
                                    password = ""
                                    usePassword = false
                                }
                                .buttonStyle(.bordered)
                                
                                Spacer()
                                
                                Button("Compress") {
                                    // TODO: Implement compression (Passo 5)
                                    print("Compress: \(archiveManager.selectedFiles.count) files into the format \(compressionFormat.rawValue)")
                                }
                                .buttonStyle(.borderedProminent)
                                .disabled(archiveManager.selectedFiles.isEmpty)
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.bottom, 32)
                    }
                }
            }
        }
        .onAppear {
            archiveManager.appState = appState
            appState.isDecompression = false
        }
    }
}
