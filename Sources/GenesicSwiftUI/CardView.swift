import SwiftUI

public struct CardView<Content: View>: View {
    public enum CardStyle {
        case elevated
        case outlined
        case filled
    }

    let content: Content
    let style: CardStyle
    let cornerRadius: CGFloat
    let padding: CGFloat

    public init(
        style: CardStyle = .elevated,
        cornerRadius: CGFloat = 12,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.style = style
        self.cornerRadius = cornerRadius
        self.padding = padding
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .strokeBorder(borderColor, lineWidth: borderWidth)
            )
            .shadow(color: shadowColor, radius: shadowRadius, x: 0, y: shadowY)
    }

    private var backgroundColor: Color {
        switch style {
        case .elevated, .outlined:
            return Color(.systemBackground)
        case .filled:
            return Color(.secondarySystemBackground)
        }
    }

    private var borderColor: Color {
        switch style {
        case .outlined:
            return Color(.separator)
        case .elevated, .filled:
            return .clear
        }
    }

    private var borderWidth: CGFloat {
        style == .outlined ? 1 : 0
    }

    private var shadowColor: Color {
        style == .elevated ? Color.black.opacity(0.1) : .clear
    }

    private var shadowRadius: CGFloat {
        style == .elevated ? 8 : 0
    }

    private var shadowY: CGFloat {
        style == .elevated ? 2 : 0
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            CardView(style: .elevated) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Elevated Card")
                        .font(.headline)
                    Text("This card has a shadow effect")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            CardView(style: .outlined) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Outlined Card")
                        .font(.headline)
                    Text("This card has a border")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            CardView(style: .filled) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Filled Card")
                        .font(.headline)
                    Text("This card has a filled background")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
    }
}
