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
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .environmentObject(archiveManager)
                    .environmentObject(appState)

                selectedFilesView
            }

            Divider()
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))

            destinationFolder
        }
        .toolbar {
            CustomToolbar<CompressionFormat, CompressionMode>(
                mainActionButtonHelp: "Compress selected files",
                mainActionButtonDisabled: archiveManager.selectedFiles.isEmpty,
                selectButtonHelp: "Select files",
                menuHelp: "Select compression format and mode",
                menuDisabled: false,
                titleOfFirstMenuSection: "Select compression format",
                selectedItemOfFirstMenuSection: .zip,
                titleOfSecondMenuSection: "Select compression mode",
                selectedItemOfSecondMenuSection: .fast,
                trashButonHelp: "Clear selection",
                trashButtonDisabled: archiveManager.selectedFiles.isEmpty,
                mainActionButtonAction: { archiveManager.compress() },
                selectButtonAction: { archiveManager.selectFiles() },
                trashButtonAction: { archiveManager.selectedFiles.removeAll() },
                onSelectItemOfFirstMenuSection: { archiveManager.selectedCompressionFormat = $0 },
                onSelectItemOfSecondMenuSection: { archiveManager.selectedCompressionMode = $0 }
            )
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
}
