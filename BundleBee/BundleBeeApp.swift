//
//  BundleBeeApp.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI
import AppKit

// TODO: Configurar cores no modo escuro

@main
struct BundleBeeApp: App {
    @StateObject private var appState = AppState.shared
    @StateObject private var fileService = FileServiceViewModel()

    var body: some Scene {
        Window("", id: "BundleBee") {
            ContentView()
                .environmentObject(fileService)
                .environmentObject(appState)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
            SidebarCommands()
        }
    }
}
