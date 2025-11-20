import SwiftUI

public struct PrimaryButtonStyle: ButtonStyle {
    public enum Size {
        case small
        case medium
        case large

        var verticalPadding: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 12
            case .large: return 16
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 24
            case .large: return 32
            }
        }

        var fontSize: Font {
            switch self {
            case .small: return .subheadline
            case .medium: return .body
            case .large: return .title3
            }
        }
    }

    let color: Color
    let size: Size
    let isFullWidth: Bool

    public init(color: Color = .blue, size: Size = .medium, isFullWidth: Bool = false) {
        self.color = color
        self.size = size
        self.isFullWidth = isFullWidth
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(size.fontSize)
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(color.opacity(configuration.isPressed ? 0.8 : 1.0))
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    VStack(spacing: 20) {
        Button("Small Button") {}
            .buttonStyle(PrimaryButtonStyle(size: .small))

        Button("Medium Button") {}
            .buttonStyle(PrimaryButtonStyle(size: .medium))

        Button("Large Button") {}
            .buttonStyle(PrimaryButtonStyle(size: .large))

        Button("Full Width Button") {}
            .buttonStyle(PrimaryButtonStyle(isFullWidth: true))

        Button("Green Button") {}
            .buttonStyle(PrimaryButtonStyle(color: .green))

        Button("Purple Button") {}
            .buttonStyle(PrimaryButtonStyle(color: .purple))
    }
    .padding()
}
