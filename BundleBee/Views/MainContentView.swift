//
//  MainContentView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct MainContentView: View {
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject private var fileService: FileServiceViewModel
    @EnvironmentObject private var appState: AppState
    
    var body: some View {
        ZStack {
            GlassCardView {
                switch appState.selectedTab {
                case .compress:
                    CompressView()
                        .environmentObject(fileService)
                        .environmentObject(appState)
                case .decompress:
                    DecompressView()
                        .environmentObject(fileService)
                        .environmentObject(appState)
                case .view:
                    ViewArchiveView()
                case .history:
                    HistoryView()
                }
            }
            .padding()
            .animation(.linear(duration: 0.25), value: appState.selectedTab)
        }
    }
}
