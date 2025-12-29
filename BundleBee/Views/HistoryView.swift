//
//  HIstoryView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct HistoryView: View {
    var body: some View {
        VStack(spacing: 0) {
            ContentUnavailableView("No history", systemImage: "clock", description: Text("Your transactions will appear here"))
            
            Spacer()
        }
    }
}
