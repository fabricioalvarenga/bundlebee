//
//  AppState.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

class AppState: ObservableObject {
    static var shared = AppState()
    @Published var selectedTab: TabType = .compress
    @Published var isDragging = false
    @Published var isDecompression = false
    @Published var pendingArchiveToOpen: URL?
    @Published var pendingFilesToCompress: [URL]?
    
    private init() {}
}
