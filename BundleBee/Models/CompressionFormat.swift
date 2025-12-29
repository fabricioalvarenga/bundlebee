//
//  CompressionFormat.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

enum CompressionFormat: Identifiable, CaseIterable{
    case zip
    case gzip
    case rar
    case sevenZip
    case tar
    case tarGz
    case bz2
    
    var id: String {
        switch self {
        case .zip: "zip"
        case .gzip: "gzip"
        case .rar: "rar"
        case .sevenZip: "7z"
        case .tar: "tar"
        case .tarGz: "tgz"
        case .bz2: "bz2"
        }
    }
    
    static var archiveExtensions: [String] {
        Array(CompressionFormat.allCases).map(\.id)
    }
}
