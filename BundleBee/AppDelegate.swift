//
//  AppDelegate.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 20/12/25.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        handleOpenedFiles(urls)
    }
    
    func handleOpenedFiles(_ urls: [URL]) {
        let appState = AppState.shared
        
        let archiveExtension = CompressionFormat.archiveExtensions
        let archive = urls.filter { archiveExtension.contains($0.pathExtension) }
        let regularFiles = urls.filter { !archiveExtension.contains($0.pathExtension) }
        
        if !archive.isEmpty {
            appState.selectedTab = .decompress
            appState.pendingArchiveToOpen = archive.first
            NotificationCenter.default.post(name: .openArchiveFile, object: regularFiles)
        } else if !regularFiles.isEmpty {
            appState.selectedTab = .compress
            appState.pendingFilesToCompress = regularFiles
            NotificationCenter.default.post(name: .openFilesToCompress, object: regularFiles)
        }
    }
}

