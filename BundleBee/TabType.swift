//
//  TabType.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

enum TabType: String, CaseIterable {
    case compress = "Compress"
    case decompress = "Descompress"
    case view = "View"
    case history = "History"
    
    var icon: String {
        switch self {
        case .compress: return "archivebox.fill"
        case .decompress: return "arrow.up.doc.fill"
        case .view: return "doc.text.magnifyingglass"
        case .history: return "clock.fill"
        }
    }
}
