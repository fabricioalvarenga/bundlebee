//
//  ArchiveError.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 30/12/25.
//

import Foundation

enum ArchiveError: LocalizedError, Equatable {
    static func == (lhs: ArchiveError, rhs: ArchiveError) -> Bool {
        lhs.errorDescription  == rhs.errorDescription
    }
    
    case fileNotFound
    case invalidArchive
    case extractionFailed
    case cannotReadArchive
    case cannotCreateFolder(String)
    case accessDeniedToFolder(String)
    case fileSystemError(Error)
    case passwordRequired
    case incorrectPassword
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .fileNotFound: "File not found."
        case .invalidArchive: "Invalid archive."
        case .extractionFailed: "Extraction failed."
        case .cannotReadArchive: "Cannot read archive."
        case .cannotCreateFolder(let path): "Cannot create folder: \(path)."
        case .accessDeniedToFolder(let path): "Access denied to folder: \(path)."
        case .fileSystemError(let error): "File system error: \(error.localizedDescription)."
        case .passwordRequired: "Password required."
        case .incorrectPassword: "Incorrect password."
        case .unknown: "Unknown error."
        }
    }
}
