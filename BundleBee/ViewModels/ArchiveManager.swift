//
//  DropZoneViewModel.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 18/12/25.
//

import Foundation

class ArchiveManager: ObservableObject {
    @Published var selectedFiles: [URL] = []
    @Published var selectedArchive: URL?
}
