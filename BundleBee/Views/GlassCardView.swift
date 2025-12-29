//
//  GlassCardView.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 26/12/25.
//

import SwiftUI

struct GlassCardView<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    
    private let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            content
        }
        .padding(16)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(colorScheme == .dark ? .white.opacity(0.08) : .black.opacity(0.08))
        )
        .shadow(color: colorScheme == .dark ? .white.opacity(0.03) : .black.opacity(0.18), radius: colorScheme == .dark ? 5: 20)
    }
}
