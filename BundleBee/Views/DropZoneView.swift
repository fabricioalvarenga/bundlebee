//
//  DropZoneView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct DropZoneView: View {
    @EnvironmentObject private var appState: AppState
    @ObservedObject var archiveManager: ArchiveManager

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 20) {
                Image(systemName: appState.isDragging ? "arrow.down.circle.fill" : "arrow.down.doc.fill")
                    .font(.system(size: 64))
                    .foregroundStyle(appState.isDragging ? .blue : .secondary)
                    .symbolEffect(.bounce, value: appState.isDragging)
                
                VStack(spacing: 8) {
                    Text(appState.isDragging ? "Drop the files here" : "Drag the files here")
                        .font(.title3)
                        .fontWeight(.medium)
                    
                    Text(appState.isDecompression ? "or click the \"Select Archive\" button below" : "or click the \"Select Files\" button bellow")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                
                if appState.isDecompression {
                    GroupBox {
                        VStack(alignment: .leading, spacing: 12) {
                            Label("Suported Formats", systemImage: "info.circle")
                                .font(.headline)
                            
                            Text("ZIP • GZIP • RAR • 7Z • TAR • TGZ")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .padding(4)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(
                        appState.isDragging ? Color.accentColor : Color.secondary.opacity(0.3),
                        style: StrokeStyle(lineWidth: 2, dash: [10, 5])
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(appState.isDragging ? Color.accentColor.opacity(0.05) : Color.clear)
                    )
            )
            
            Button(appState.isDecompression ? "Select Archive" : "Select Files") {
                archiveManager.selectFiles()
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
            .padding(.top, 8)
            
        }
        .padding(.bottom, 16)
        .onDrop(of: [.fileURL], isTargeted: $appState.isDragging) { providers in
            archiveManager.handleDrop(providers: providers)
        }
    }
    
  
}
