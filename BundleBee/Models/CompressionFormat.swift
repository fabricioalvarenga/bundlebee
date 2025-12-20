//
//  CompressionFormat.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

enum CompressionFormat: String, CaseIterable {
    case zip = "zip"
    case gzip = "gzip"
    case rar = "rar"
    case sevenZip = "7z"
    case tar = "tar"
    case tarGz = "tgz"
    
    static var archiveExtensions: [String] {
        Array(CompressionFormat.allCases).map(\.rawValue)
    }
}
