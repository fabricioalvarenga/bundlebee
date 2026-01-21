//
//  FolderBookMark.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 18/01/26.
//

import Foundation

struct FolderBookmark: Codable, Identifiable {
    let id: URL
    let data: Data
    
    static let key = "com.alvarenga.fabricio.BundleBee.securityScopedFolderBookmarks"
}
