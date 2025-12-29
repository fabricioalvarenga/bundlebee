//
//  ContentView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var archiveManager: ArchiveManager
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            MainContentView()
        }
        .controlSize(.large)
    }
}
