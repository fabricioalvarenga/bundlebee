//
//  CompressMode.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 26/12/25.
//

import Foundation

enum CompressionMode: Identifiable, CaseIterable {
    case fast
    case normal
    case best
    
    var id: String {
        switch self {
        case .fast: "Fast"
        case .normal: "Normal"
        case .best: "Best"
        }
       
    }
    static var compressMode: [String] {
        Array(CompressionMode.allCases).map(\.id)
    }
}
