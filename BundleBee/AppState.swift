//
//  AppState.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

class AppState: ObservableObject {
    static let shared = AppState()
    @Published var selectedTab: TabType = .compress
    @Published var isDragging = false
    
    private init() {}
}
