//
//  CompressView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

// TODO: Use password to compress
struct CompressView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var archiveManager: ArchiveManager
    @EnvironmentObject private var appState: AppState
    @State private var scale = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                headerView
                Spacer()
            }
                
            ZStack {
                DropZoneView()
                    .environmentObject(archiveManager)
                    .environmentObject(appState)

                selectedFilesView
            }

            Divider()
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))

            destinationFolder
        }
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                trashButton
            }
            
            ToolbarItemGroup(placement: .secondaryAction) {
                toolbarItems
            }
            
        }
        .onAppear {
            appState.isDecompression = false
        }
    }

    private var headerView: some View {
        HStack {
            Text(archiveManager.selectedFiles.isEmpty ? "No File Selected" : "\(archiveManager.selectedFiles.count) Files Selected")
                .scaleEffect(scale)
                .onChange(of: archiveManager.selectedFiles.count) { _, _ in
                    withAnimation(.spring(duration: 0.5)) {
                        scale = 1.3
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        withAnimation(.spring(duration: 0.5)) {
                            scale = 1.0
                        }
                    }
                }
        }
        .font(.title)
        .fontWeight(.semibold)

    }

    private var selectedFilesView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(archiveManager.selectedFiles, id: \.self) { file in
                    FileRowView(url: file) {
                        archiveManager.selectedFiles.removeAll { $0 == file }
                    }
                }
            }
        }
        .padding(8)
    }

    private var destinationFolder: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label("Destination Folder", systemImage: "folder")
                .font(.headline)
                .labelStyle(.titleAndIcon)
            
            HStack {
                if let folder = archiveManager.compressionDestinationFolder?.path {
                    Text(folder)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    archiveManager.selectDestinationFolder()
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
    
    private var toolbarItems: some View {
        HStack {
            Button {
                archiveManager.selectFiles()
            } label: {
                Image(systemName: "doc.badge.plus")
            }
            .help("Select files")
            
            Menu {
                Section("Select compression format") {
                    ForEach(CompressionFormat.allCases) { format in
                        Button {
                            archiveManager.selectedCompressionFormat = format
                        } label: {
                            // TODO: Alinhar os textos
                            HStack {
                                if archiveManager.selectedCompressionFormat == format {
                                    Image(systemName: "checkmark")
                                }
                                
                                Text(format.id.uppercased())
                            }
                        }
                    }
                }
                
                Section("Select compression mode") {
                    ForEach(CompressionMode.allCases) { mode in
                        Button {
                            archiveManager.selectedCompressionMode = mode
                        } label: {
                            // TODO: Alinhar os textos
                            HStack {
                                if archiveManager.selectedCompressionMode == mode {
                                    Image(systemName: "checkmark")
                                }
                                
                                Text(mode.id)
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "ellipsis.circle")
            }
            .help("Compression format and mode")
            
            Button {
                // TODO: Implement compression (Passo 5)
            } label: {
                HStack {
                    Image(systemName: "doc.zipper")
                }
            }
            .disabled(archiveManager.selectedFiles.isEmpty)
            .help("Compress selected files")
        }
    }
    
    private var trashButton: some View {
        Button {
            archiveManager.selectedFiles.removeAll()
        } label: {
            Image(systemName: "trash")
        }
        .disabled(archiveManager.selectedFiles.isEmpty)
        .help("Clear selection")
    }
    
    
    
}
