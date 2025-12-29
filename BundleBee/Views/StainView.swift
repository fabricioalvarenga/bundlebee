//
//  StainView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 26/12/25.
//

import SwiftUI

struct StainView: View {
    @EnvironmentObject private var appState: AppState
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        .accentColor.opacity(colorScheme == .dark ? 0.14 : 0.12),
                        .clear
                    ],
                    startPoint: .bottomTrailing,
                    endPoint: .topLeading
                )
            )
            .blur(radius: colorScheme == .dark ? 120 : 90)
    }
}
