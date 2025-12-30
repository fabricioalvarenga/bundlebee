//
//  CompressMode.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 26/12/25.
//

import Foundation

enum CompressionMode: String, Identifiable, CaseIterable {
    case fast = "Fast"
    case normal = "Normal"
    case best = "Best"
    
    var id: String {
        self.rawValue
    }
    static var compressMode: [String] {
        Array(CompressionMode.allCases).map(\.id)
    }
}
