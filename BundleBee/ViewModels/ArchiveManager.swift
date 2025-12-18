//
//  DropZoneViewModel.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 18/12/25.
//

import SwiftUI

class ArchiveManager: ObservableObject {
    @EnvironmentObject var appState: AppState
    @Published var selectedFiles: [URL] = []
    @Published var selectedArchive: URL?
}
