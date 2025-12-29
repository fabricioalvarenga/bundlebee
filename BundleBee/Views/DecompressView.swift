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
                    .frame(height: archiveManager.selectedArchive == nil ? 220 : 56)
                    .environmentObject(archiveManager)
                    .environmentObject(appState)
                
                if let archive = archiveManager.selectedArchive {
                    FileRowView(url: archive) {
                        archiveManager.selectedArchive = nil
                    }
                }
            }
            
            Divider()
                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.5) : .black.opacity(0.5))
            
            destinationFolder
        }
        .onAppear {
            appState.isDecompression = true
        }
    }
    
    private var headerView: some View {
        HStack {
            Text(archiveManager.selectedArchive == nil ? "No Archive Selected" : "Archive Selected")
                .scaleEffect(scale)
                .onChange(of: archiveManager.selectedArchive) { _, _ in
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
