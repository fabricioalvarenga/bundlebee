//
//  FileRowview.swift
//  BundleBee
//
//  Created by FABRICIO ALVARENGA on 17/12/25.
//

import SwiftUI

struct FileRowView: View {
    private let url: URL
    private let onRemove: () -> Void
    
    init(url: URL?, onRemove: @escaping () -> Void) {
        self.url = url ?? URL(fileURLWithPath: "")
        self.onRemove = onRemove
    }

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "doc")  // TODO: Mostrar um tipo de ícone para cada tipo de arquivo
                .font(.system(size: 40))
                .foregroundStyle(Color.accentColor)

            VStack(alignment: .leading, spacing: 2) {
                Text(url.lastPathComponent)
                    .font(.subheadline)

                Text(url.deletingLastPathComponent().path)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                if let fileSize = try? FileManager.default.attributesOfItem(
                    atPath: url.path)[.size] as? Int64
                {
                    Text(
                        ByteCountFormatter.string(
                            fromByteCount: fileSize, countStyle: .file)
                    )
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                }
            }

            Spacer()

            Button {
                onRemove()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}
