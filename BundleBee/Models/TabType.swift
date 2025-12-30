//
//  TabType.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

enum TabType: String, CaseIterable, Identifiable {
    case compress = "Compress"
    case decompress = "Decompress"
    case view = "View"
    case history = "History"
    
    var id: String {
        self.rawValue
    }
    
    var icon: String {
        switch self {
        case .compress: "archivebox.fill"
        case .decompress: "arrow.up.doc.fill"
        case .view: "doc.text.magnifyingglass"
        case .history: "clock.fill"
        }
    }
}
