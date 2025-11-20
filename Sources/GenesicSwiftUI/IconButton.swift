import SwiftUI

public struct IconButton: View {
    let icon: String
    let size: ButtonSize
    let style: ButtonStyle
    let color: Color
    let action: () -> Void

    public init(
        icon: String,
        size: ButtonSize = .medium,
        style: ButtonStyle = .filled,
        color: Color = .blue,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.size = size
        self.style = style
        self.color = color
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize))
                .foregroundColor(style.foregroundColor(for: color))
                .frame(width: size.value, height: size.value)
                .background(style.backgroundColor(for: color))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .strokeBorder(color, lineWidth: style == .outlined ? 1.5 : 0)
                )
        }
        .buttonStyle(LabelButtonStyle())
    }

    public enum ButtonSize {
        case small, medium, large

        var value: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 44
            case .large: return 56
            }
        }

        var iconSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 18
            case .large: return 24
            }
        }
    }

    public enum ButtonStyle {
        case filled
        case outlined
        case ghost

        func backgroundColor(for color: Color) -> Color {
            switch self {
            case .filled:
                return color
            case .outlined:
                return .clear
            case .ghost:
                return color.opacity(0.15)
            }
        }

        func foregroundColor(for color: Color) -> Color {
            switch self {
            case .filled:
                return .white
            case .outlined, .ghost:
                return color
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Sizes")
                    .font(.headline)

                HStack(spacing: 16) {
                    IconButton(icon: "heart.fill", size: .small) { print("Small") }
                    IconButton(icon: "heart.fill", size: .medium) { print("Medium") }
                    IconButton(icon: "heart.fill", size: .large) { print("Large") }
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Filled Style")
                    .font(.headline)

                HStack(spacing: 16) {
                    IconButton(icon: "star.fill", color: .yellow) { print("Star") }
                    IconButton(icon: "bookmark.fill", color: .purple) { print("Bookmark") }
                    IconButton(icon: "bell.fill", color: .red) { print("Bell") }
                    IconButton(icon: "message.fill", color: .green) { print("Message") }
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Outlined Style")
                    .font(.headline)

                HStack(spacing: 16) {
                    IconButton(icon: "heart", style: .outlined, color: .red) { print("Heart") }
                    IconButton(icon: "star", style: .outlined, color: .orange) { print("Star") }
                    IconButton(icon: "bookmark", style: .outlined, color: .blue) { print("Bookmark") }
                    IconButton(icon: "square.and.arrow.up", style: .outlined, color: .green) { print("Share") }
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Ghost Style")
                    .font(.headline)

                HStack(spacing: 16) {
                    IconButton(icon: "trash", style: .ghost, color: .red) { print("Delete") }
                    IconButton(icon: "pencil", style: .ghost, color: .blue) { print("Edit") }
                    IconButton(icon: "plus", style: .ghost, color: .green) { print("Add") }
                    IconButton(icon: "xmark", style: .ghost, color: .gray) { print("Close") }
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Common Actions")
                    .font(.headline)

                HStack(spacing: 16) {
                    IconButton(icon: "play.fill", color: .blue) { print("Play") }
                    IconButton(icon: "pause.fill", color: .orange) { print("Pause") }
                    IconButton(icon: "stop.fill", color: .red) { print("Stop") }
                    IconButton(icon: "forward.fill", color: .purple) { print("Forward") }
                }
            }
        }
        .padding()
    }
}
