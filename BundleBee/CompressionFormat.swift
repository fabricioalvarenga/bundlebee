//
//  CompressionFormat.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import Foundation

enum CompressionFormat: String, CaseIterable {
    case zip = "ZIP"
    case gzip = "GZIP"
    case rar = "RAR"
    case sevenZip = "7Z"
    case tar = "TAR"
    case tarGz = "TAR.GZ"
}
