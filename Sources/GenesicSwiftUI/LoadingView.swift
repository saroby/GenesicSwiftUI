import SwiftUI

public struct LoadingView: View {
    public enum Size {
        case small
        case medium
        case large

        var value: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 40
            case .large: return 60
            }
        }
    }

    let size: Size
    let tint: Color
    let message: String?

    public init(size: Size = .medium, tint: Color = .blue, message: String? = nil) {
        self.size = size
        self.tint = tint
        self.message = message
    }

    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: tint))
                .scaleEffect(size.value / 20)
                .frame(width: size.value, height: size.value)

            if let message = message {
                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        LoadingView(size: .small)
        LoadingView(size: .medium, message: "Loading...")
        LoadingView(size: .large, tint: .green, message: "Please wait")
    }
}
