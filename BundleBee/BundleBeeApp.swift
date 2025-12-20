//
//  BundleBeeApp.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI
import AppKit

@main
struct BundleBeeApp: App {
    @NSApplicationDelegateAdaptor private var appDelegate: AppDelegate
    @StateObject private var appState = AppState.shared
    
    var body: some Scene {
        Window("", id: "BundleBee") {
            ContentView()
                .environmentObject(appState)
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            CommandGroup(replacing: .newItem) {}
            SidebarCommands()
        }
        .handlesExternalEvents(matching: Set(arrayLiteral: "*"))
    }
}
