//
//  ArchiveManager.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 31/12/25.
//

import Foundation

class ArchiveManager {
    static let shared = ArchiveManager()
    
    private init() {}
    
    func extractArchive(
        from sourceURL: URL,
        to destinationURL: URL? = nil,
        password: String? = nil,
        progressHandler: ((Double) -> Void)? = nil
    ) async throws -> URL {
        let destination = destinationURL ?? sourceURL.deletingLastPathComponent()
        
        let archiveName = sourceURL.deletingPathExtension().lastPathComponent
        let extractionFolder = destination.appending(path: archiveName)
        
        let extractedURL: URL = try await Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { throw ArchiveError.unknown }
            
            try FileManager.default.createDirectory(at: extractionFolder, withIntermediateDirectories: true, attributes: nil)
            
            let success = self.unzipUsingProcess(
                sourceURL: sourceURL,
                destinationURL: extractionFolder,
                password: password,
                progressHandler: progressHandler
            )
            
            guard success else { throw ArchiveError.extractionFailed }
            
            return extractionFolder
        }.value
        
        return await MainActor.run { extractedURL }
    }
    
    private func unzipUsingProcess(
        sourceURL: URL,
        destinationURL: URL,
        password: String?,
        progressHandler: ((Double) -> Void)?
    ) -> Bool {
        return true
    }
}
