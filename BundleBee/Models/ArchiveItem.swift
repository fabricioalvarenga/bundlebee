//
//  ArchiveItem.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 30/12/25.
//

import Foundation

struct ArchiveItem: Identifiable {
    let id = UUID()
    let name: String
    let size: Int64
    let isDirectory: Bool
    
    var formmatedSize: String {
        ByteCountFormatter.string(fromByteCount: size, countStyle: .file)
    }
}
