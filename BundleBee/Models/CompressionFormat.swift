//
//  CompressionFormat.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

enum CompressionFormat: String, Identifiable, CaseIterable {
    case zip = "Zip"
    case gzip = "Gzip"
    case rar = "Rar"
    case sevenZip = "7z"
    case tar = "Tar"
    case tarGz = "Tgz"
    case bz2 = "Bz2"
    
    var id: String {
        self.rawValue
    }
    
    static var archiveExtensions: [String] {
        Array(CompressionFormat.allCases).map { $0.rawValue }
    }
}
