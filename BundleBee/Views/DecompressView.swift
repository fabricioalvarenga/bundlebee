//
//  DecompressView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct DecompressView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var fileService: FileServiceViewModel
    @EnvironmentObject private var appState: AppState
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        VStack(spacing: 16) {
            headerView

            DropZoneView(makeDropZoneVisible: fileService.selectedArchive == nil) {
                FileRowView(url: fileService.selectedArchive) {
                    fileService.selectedArchive = nil
                }
                .opacity(fileService.selectedArchive == nil ? 0 : 1)
            }
            .environmentObject(fileService)
            .environmentObject(appState)
            .animation(.default, value: fileService.selectedArchive)

            Divider()
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))

            destinationFolder
        }
        .onAppear {
            appState.isDecompression = true
        }
        .toolbar {
            CustomToolbar<ExtractOption, ExtractOption>(
                mainActionButtonHelp: "Extract selected archive",
                mainActionButtonDisabled: fileService.selectedArchive == nil,
                selectButtonHelp: "Select archive",
                selectedItemOfFirstMenuSection: .empty,
                selectedItemOfSecondMenuSection: .empty,
                trashButonHelp: "Clear selection",
                trashButtonDisabled: fileService.selectedArchive == nil,
                mainActionButtonAction: { fileService.extract() },
                selectButtonAction: { fileService.selectFiles() },
                trashButtonAction: { fileService.selectedArchive = nil }
            )
        }
        .onChange(of: fileService.extractionResult) { _, newValue in
            guard let newValue else { return }
            
            // TODO: Necessário mostrar mensagem na tela informando ao usuário sobre o erro ocorrido
            switch newValue {
            case .success(let url): print("success: \(url)")
            case .failure(let error): print(error.localizedDescription)
            }
        }
    }

    private var headerView: some View {
        HStack {
            Text(
                fileService.selectedArchive == nil ? "No Archive Selected" : "Archive Selected"
            )
            .scaleEffect(scale)
        }
        .font(.title)
        .fontWeight(.semibold)
        .onChange(of: fileService.selectedArchive) { _, newValue in
            withAnimation(.easeOut(duration: 0.5)) { scale = 1.3 }
            withAnimation(.easeIn(duration: 0.5).delay(0.5)) { scale = 1.0 }
        }
    }

    private var destinationFolder: some View {
        VStack(alignment: .leading, spacing: 0) {
            Label("Destination Folder", systemImage: "folder")
                .font(.headline)
                .labelStyle(.titleAndIcon)

            HStack {
                if let folder = fileService.decompressionDestinationFolder?.path {
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
