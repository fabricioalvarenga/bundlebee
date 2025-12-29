//
//  ViewArchiveView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct ViewArchiveView: View {
    var body: some View {
        VStack(spacing: 0) {
            ContentUnavailableView("No archive selected", systemImage: "doc.text.magnifyingglass", description: Text("Drag and drop an archive to view its contents"))
            
            Spacer()
        }
    }
}
