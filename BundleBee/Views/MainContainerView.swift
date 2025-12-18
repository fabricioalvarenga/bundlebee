//
//  MainContainerView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct MainContainerView: View {
    @StateObject private var appState = AppState.shared
    
    var body: some View {
        MainContentView(appState: appState)
    }
}

struct MainContentView: View {
    @ObservedObject var appState: AppState
    
    var body: some View {
        ZStack {
            switch appState.selectedTab {
            case .compress:
                CompressView(isDragging: $appState.isDragging)
            case .decompress:
                DecompressView(isDragging: $appState.isDragging)
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
