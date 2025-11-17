import SwiftUI

public struct NotificationBadge: View {
    let count: Int
    let maxCount: Int
    let color: Color
    let size: BadgeSize

    public init(
        count: Int,
        maxCount: Int = 99,
        color: Color = .red,
        size: BadgeSize = .medium
    ) {
        self.count = count
        self.maxCount = maxCount
        self.color = color
        self.size = size
    }

    private var displayText: String {
        if count > maxCount {
            return "\(maxCount)+"
        } else {
            return "\(count)"
        }
    }

    public var body: some View {
        if count > 0 {
            Text(displayText)
                .font(size.font)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, size.horizontalPadding)
                .padding(.vertical, size.verticalPadding)
                .background(
                    Capsule()
                        .fill(color)
                )
                .frame(minWidth: size.minWidth)
        }
    }

    public enum BadgeSize {
        case small
        case medium
        case large

        var font: Font {
            switch self {
            case .small: return .caption2
            case .medium: return .caption
            case .large: return .subheadline
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return 4
            case .medium: return 6
            case .large: return 8
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small: return 2
            case .medium: return 3
            case .large: return 4
            }
        }

        var minWidth: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 20
            case .large: return 24
            }
        }
    }
}

public extension View {
    func badge(count: Int, color: Color = .red, size: NotificationBadge.BadgeSize = .medium) -> some View {
        overlay(
            NotificationBadge(count: count, color: color, size: size),
            alignment: .topTrailing
        )
    }
}

#Preview {
    VStack(spacing: 40) {
        VStack(spacing: 16) {
            Text("Standalone Badges")
                .font(.headline)

            HStack(spacing: 16) {
                NotificationBadge(count: 5, size: .small)
                NotificationBadge(count: 23, size: .medium)
                NotificationBadge(count: 156, size: .large)
            }

            HStack(spacing: 16) {
                NotificationBadge(count: 999, color: .blue)
                NotificationBadge(count: 0, color: .green)
            }
        }

        VStack(spacing: 16) {
            Text("Badges on Icons")
                .font(.headline)

            HStack(spacing: 32) {
                Image(systemName: "bell.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                    .badge(count: 3)

                Image(systemName: "message.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.green)
                    .badge(count: 12, color: .green)

                Image(systemName: "envelope.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.orange)
                    .badge(count: 99, color: .orange)

                Image(systemName: "cart.fill")
                    .font(.system(size: 40))
                    .foregroundColor(.purple)
                    .badge(count: 156, color: .purple)
            }
        }

        VStack(spacing: 16) {
            Text("Badges on Buttons")
                .font(.headline)

            Button(action: {}) {
                Text("Notifications")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .badge(count: 5)
            .buttonStyle(LabelButtonStyle())
        }
    }
    .padding()
}
