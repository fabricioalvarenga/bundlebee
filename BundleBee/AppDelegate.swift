//
//  AppDelegate.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 20/12/25.
//

import AppKit

class AppDelegate: NSObject, NSApplicationDelegate {
    // TODO: Quando tento arrastar para o Dock um arquivo de extensão qualquer, juntamente com um arquivo .zip:
    // 1. "urls" não contém o arquivo .zip se o app estiver fechado
    // 2. "urls" não contém os outros arquivos (apenas o arquivo .zip) se o app estiver em execução
    // Necessário corrigir isso. Todos os arquivos devem ser "aceitos" no Dock e neste caso, por se tratarem de arquivos de extensões
    // diversas, devem ir para compressão
    func application(_ application: NSApplication, open urls: [URL]) {
        guard !urls.isEmpty else { return }
//        handleOpenedFiles(urls)  // Handle files dropped on Dock
    }
    
    func handleOpenedFiles(_ urls: [URL]) {
        let archiveExtension = CompressionFormat.archiveExtensions
        let archive = urls.filter { archiveExtension.contains($0.pathExtension) }
        
        if urls.isEmpty { return }
        
        if urls.count > 1 {
            handleFilesToComppress(urls)
        } else if !archive.isEmpty {
            handleArchiveToOpen(archive.first)
        } else {
            handleFilesToComppress(urls)
        }
    }
    
    func handleFilesToComppress(_ urls: [URL]) {
        let appState = AppState.shared
        appState.selectedTab = .compress
        appState.pendingFilesToCompress = urls
        NotificationCenter.default.post(name: .openFilesToCompress, object: urls)
    }
    
    func handleArchiveToOpen(_ archive: URL?) {
        let appState = AppState.shared
        appState.selectedTab = .decompress
        appState.pendingArchiveToOpen = archive
        NotificationCenter.default.post(name: .openArchiveFile, object: archive)
        
    }
}
