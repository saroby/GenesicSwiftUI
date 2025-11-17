import SwiftUI

public struct TagView: View {
    let text: String
    let icon: String?
    let color: Color
    let onDelete: (() -> Void)?

    public init(
        text: String,
        icon: String? = nil,
        color: Color = .blue,
        onDelete: (() -> Void)? = nil
    ) {
        self.text = text
        self.icon = icon
        self.color = color
        self.onDelete = onDelete
    }

    public var body: some View {
        HStack(spacing: 6) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.caption)
            }

            Text(text)
                .font(.subheadline)

            if let onDelete = onDelete {
                Button(action: onDelete) {
                    Image(systemName: "xmark")
                        .font(.caption2)
                }
                .buttonStyle(LabelButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(color.opacity(0.15))
        .foregroundColor(color)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(color.opacity(0.3), lineWidth: 1)
        )
    }
}

public struct TagGroupView: View {
    @Binding var tags: [String]
    let color: Color
    let allowDelete: Bool

    public init(
        tags: Binding<[String]>,
        color: Color = .blue,
        allowDelete: Bool = true
    ) {
        self._tags = tags
        self.color = color
        self.allowDelete = allowDelete
    }

    public var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(Array(tags.enumerated()), id: \.offset) { index, tag in
                TagView(
                    text: tag,
                    color: color,
                    onDelete: allowDelete ? {
                        tags.remove(at: index)
                    } : nil
                )
            }
        }
    }
}

#Preview {
    struct TagPreview: View {
        @State private var tags1 = ["Swift", "SwiftUI", "iOS", "Xcode"]
        @State private var tags2 = ["Design", "Development", "Testing"]

        var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Individual Tags")
                            .font(.headline)

                        VStack(alignment: .leading, spacing: 12) {
                            TagView(text: "Technology", color: .blue)
                            TagView(text: "Featured", icon: "star.fill", color: .orange)
                            TagView(text: "Premium", icon: "crown.fill", color: .purple)
                            TagView(
                                text: "Removable",
                                color: .red,
                                onDelete: { print("Deleted") }
                            )
                        }
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tag Group (Editable)")
                            .font(.headline)

                        TagGroupView(tags: $tags1, color: .blue)

                        Text("Selected: \(tags1.count) tags")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        Text("Tag Group (Read-only)")
                            .font(.headline)

                        TagGroupView(tags: $tags2, color: .green, allowDelete: false)
                    }
                }
                .padding()
            }
        }
    }

    return TagPreview()
}
