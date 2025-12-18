//
//  AppState.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

class AppState: ObservableObject {
    @Published var selectedTab: TabType = .compress
    @Published var isDragging = false
    @Published var isDecompression = false
}
