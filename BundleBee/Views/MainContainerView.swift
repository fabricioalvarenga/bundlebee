//
//  MainContentView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct MainContentView: View {
    @EnvironmentObject private var appState: AppState
    @StateObject private var archiveManager = ArchiveManager()
    
    var body: some View {
        ZStack {
            switch appState.selectedTab {
            case .compress:
                CompressView(archiveManager: archiveManager)
                    .environmentObject(appState)
            case .decompress:
                DecompressView(archiveManager: archiveManager)
                    .environmentObject(appState)
            case .view:
                ViewArchiveView()
            case .history:
                HistoryView()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(nsColor: .textBackgroundColor))
    }
}
