//
//  DecompressView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct DecompressView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var archiveManager: ArchiveManager
    @EnvironmentObject private var appState: AppState
    @State private var scale: CGFloat = 1.0
    @State private var frameHeight: CGFloat = 0.0
    
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

                FileRowView(url: archiveManager.selectedArchive) {
                    archiveManager.selectedArchive = nil
                }
                .opacity(archiveManager.selectedArchive == nil ? 0 : 1)
                .frame(height: archiveManager.selectedArchive == nil ? 0 : nil)
            }
            .frame(height: frameHeight)
            .animation(.spring(duration: 0.5).delay(0.5), value: archiveManager.selectedArchive) // Essa animaçõa es
            .onChange(of: archiveManager.selectedArchive) { _, newValue in
                withAnimation(.spring(duration: 0.5).delay(0.5)) {
                    frameHeight = newValue == nil ? 220 : 56
                }
            }

            Divider()
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))

            destinationFolder
        }
        .onAppear {
            appState.isDecompression = true
            frameHeight = archiveManager.selectedArchive == nil ? 220 : 56
        }
        .toolbar {
            CustomToolbar<ExtractOption, ExtractOption>(
                mainActionButtonHelp: "Extract selected archive",
                mainActionButtonDisabled: archiveManager.selectedArchive == nil,
                selectButtonHelp: "Select archive",
                selectedItemOfFirstMenuSection: .empty,
                selectedItemOfSecondMenuSection: .empty,
                trashButonHelp: "Clear selection",
                trashButtonDisabled: archiveManager.selectedArchive == nil,
                mainActionButtonAction: { archiveManager.extract() },
                selectButtonAction: { archiveManager.selectFiles() },
                trashButtonAction: { archiveManager.selectedArchive = nil }
            )
        }
    }

    private var headerView: some View {
        HStack {
            Text(
                archiveManager.selectedArchive == nil
                    ? "No Archive Selected" : "Archive Selected"
            )
            .scaleEffect(scale)
        }
        .font(.title)
        .fontWeight(.semibold)
        .onChange(of: archiveManager.selectedArchive) { _, newValue in
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
                if let folder = archiveManager.decompressionDestinationFolder?.path {
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
