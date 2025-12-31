//
//  CompressView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

// TODO: Use password to compress
// TODO: Animar a inserção e exclusão de arquivos na "drop zone"
struct CompressView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var fileService: FileService
    @EnvironmentObject private var appState: AppState
    @State private var scale = 1.0

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Spacer()
                headerView
                Spacer()
            }
                
            DropZoneView(makeDropZoneVisible: fileService.selectedFiles.isEmpty) {
                selectedFilesView
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .environmentObject(fileService)
            .environmentObject(appState)

            Divider()
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))

            destinationFolder
        }
        .toolbar {
            CustomToolbar<CompressionFormat, CompressionMode>(
                mainActionButtonHelp: "Compress selected files",
                mainActionButtonDisabled: fileService.selectedFiles.isEmpty,
                selectButtonHelp: "Select files",
                menuHelp: "Select compression format and mode",
                menuDisabled: false,
                titleOfFirstMenuSection: "Select compression format",
                selectedItemOfFirstMenuSection: .zip,
                titleOfSecondMenuSection: "Select compression mode",
                selectedItemOfSecondMenuSection: .fast,
                trashButonHelp: "Clear selection",
                trashButtonDisabled: fileService.selectedFiles.isEmpty,
                mainActionButtonAction: { fileService.compress() },
                selectButtonAction: { fileService.selectFiles() },
                trashButtonAction: { fileService.selectedFiles.removeAll() },
                onSelectItemOfFirstMenuSection: { fileService.selectedCompressionFormat = $0 },
                onSelectItemOfSecondMenuSection: { fileService.selectedCompressionMode = $0 }
            )
        }
        .onAppear {
            appState.isDecompression = false
        }
    }

    private var headerView: some View {
        HStack {
            Text(fileService.selectedFiles.isEmpty ? "No File Selected" : "\(fileService.selectedFiles.count) Files Selected")
                .scaleEffect(scale)
                .onChange(of: fileService.selectedFiles.count) { _, _ in
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
                ForEach(fileService.selectedFiles, id: \.self) { file in
                    FileRowView(url: file) {
                        fileService.selectedFiles.removeAll { $0 == file }
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
                if let folder = fileService.compressionDestinationFolder?.path {
                    Text(folder)
                        .lineLimit(1)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                Button {
                    fileService.selectDestinationFolder()
                } label: {
                    Image(systemName: "ellipsis")
                }
            }
        }
    }
}
