import SwiftUI

public struct BadgeView: View {
    public enum BadgeStyle {
        case filled
        case outlined
        case soft

        func backgroundColor(for color: Color) -> Color {
            switch self {
            case .filled:
                return color
            case .outlined:
                return .clear
            case .soft:
                return color.opacity(0.15)
            }
        }

        func foregroundColor(for color: Color) -> Color {
            switch self {
            case .filled:
                return .white
            case .outlined, .soft:
                return color
            }
        }
    }

    public enum Size {
        case small
        case medium
        case large

        var fontSize: Font {
            switch self {
            case .small: return .caption2
            case .medium: return .caption
            case .large: return .subheadline
            }
        }

        var padding: EdgeInsets {
            switch self {
            case .small: return EdgeInsets(top: 2, leading: 6, bottom: 2, trailing: 6)
            case .medium: return EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8)
            case .large: return EdgeInsets(top: 6, leading: 12, bottom: 6, trailing: 12)
            }
        }
    }

    let text: String
    let color: Color
    let style: BadgeStyle
    let size: Size

    public init(
        _ text: String,
        color: Color = .blue,
        style: BadgeStyle = .filled,
        size: Size = .medium
    ) {
        self.text = text
        self.color = color
        self.style = style
        self.size = size
    }

    public var body: some View {
        Text(text)
            .font(size.fontSize)
            .fontWeight(.medium)
            .foregroundColor(style.foregroundColor(for: color))
            .padding(size.padding)
            .background(style.backgroundColor(for: color))
            .cornerRadius(6)
            .overlay(
                RoundedRectangle(cornerRadius: 6)
                    .strokeBorder(color, lineWidth: style == .outlined ? 1 : 0)
            )
    }
}

#Preview {
    VStack(spacing: 20) {
        HStack(spacing: 12) {
            BadgeView("New", color: .blue, style: .filled, size: .small)
            BadgeView("Featured", color: .green, style: .filled, size: .medium)
            BadgeView("Premium", color: .purple, style: .filled, size: .large)
        }

        HStack(spacing: 12) {
            BadgeView("Draft", color: .gray, style: .outlined, size: .small)
            BadgeView("Active", color: .green, style: .outlined, size: .medium)
            BadgeView("Archived", color: .orange, style: .outlined, size: .large)
        }

        HStack(spacing: 12) {
            BadgeView("Hot", color: .red, style: .soft, size: .small)
            BadgeView("Popular", color: .blue, style: .soft, size: .medium)
            BadgeView("Trending", color: .pink, style: .soft, size: .large)
        }
    }
    .padding()
}
