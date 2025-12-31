//
//  DropZoneView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct DropZoneView: View {
    @EnvironmentObject private var appState: AppState
    @EnvironmentObject private var fileService: FileService

    var body: some View {
        ZStack {
            let opacity = (appState.isDecompression && fileService.selectedArchive == nil) || (!appState.isDecompression && fileService.selectedFiles.isEmpty) ? 1.0 : 0.0
            
            VStack(spacing: 20) {
                dropTextView
                    .opacity(opacity)
                    .frame(height: opacity == 0.0 ? 0 : nil)

                supportedFilesView
                    .opacity(opacity == 1.0 && appState.isDecompression ? 1.0 : 0.0)
                    .frame(height: opacity == 1.0 && appState.isDecompression ? nil : 0)
            }
            
            backgroundView
        }
        .onDrop(of: [.fileURL], isTargeted: $appState.isDragging) { providers in
            fileService.handleDrop(providers: providers)
        }
    }
    
    var dropTextView: some View {
        VStack(spacing: 8) {
            Image(systemName: appState.isDragging ? "arrow.down.circle.fill" : "arrow.down.doc.fill")
            .font(.system(size: 64))
            .foregroundStyle(appState.isDragging ? Color.accentColor : .secondary)
            .symbolEffect(.bounce, value: appState.isDragging)

            Text(appState.isDragging ? (appState.isDecompression ? "Drop the archive here" : "Drop the files here") : (appState.isDecompression ? "Drag the archive here" : "Drag the files here"))
                .font(.title3)
                .fontWeight(.medium)
            
            Text(appState.isDragging ? "" : (appState.isDecompression ? "or click the \"Select Archive\" on tool bar" : "or click the \"Select Files\" on tool bar"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var supportedFilesView: some View {
        VStack(spacing: 8) {
            Label("Suported Formats", systemImage: "info.circle")
                .font(.title3)
                .fontWeight(.medium)

            Text(CompressionFormat.archiveExtensions.joined(separator: " • "))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
    }
    
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: 8)
            .strokeBorder(
                appState.isDragging ? Color.accentColor : .secondary.opacity(0.3),
                style: StrokeStyle(lineWidth: 2, dash: [10, 5])
            )
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(appState.isDragging ? Color.accentColor.opacity(0.05) : .clear)
            )
    }
}
