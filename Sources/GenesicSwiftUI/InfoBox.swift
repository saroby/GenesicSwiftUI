import SwiftUI

public struct InfoBox: View {
    let title: String?
    let message: String
    let type: InfoBoxType
    let isDismissible: Bool
    let onDismiss: (() -> Void)?

    public init(
        title: String? = nil,
        message: String,
        type: InfoBoxType = .info,
        isDismissible: Bool = false,
        onDismiss: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.type = type
        self.isDismissible = isDismissible
        self.onDismiss = onDismiss
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: type.icon)
                .font(.title3)
                .foregroundColor(type.color)

            VStack(alignment: .leading, spacing: 4) {
                if let title = title {
                    Text(title)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                }

                Text(message)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }

            Spacer()

            if isDismissible {
                Button(action: {
                    onDismiss?()
                }) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(LabelButtonStyle())
            }
        }
        .padding()
        .background(type.color.opacity(0.1))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(type.color.opacity(0.3), lineWidth: 1)
        )
        .cornerRadius(8)
    }

    public enum InfoBoxType {
        case info
        case success
        case warning
        case error

        var color: Color {
            switch self {
            case .info: return .blue
            case .success: return .green
            case .warning: return .orange
            case .error: return .red
            }
        }

        var icon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
            }
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 20) {
            InfoBox(
                title: "Information",
                message: "This is an informational message to help you understand something important.",
                type: .info
            )

            InfoBox(
                title: "Success",
                message: "Your action was completed successfully!",
                type: .success,
                isDismissible: true,
                onDismiss: { print("Dismissed") }
            )

            InfoBox(
                title: "Warning",
                message: "Please be aware of this important warning before proceeding.",
                type: .warning
            )

            InfoBox(
                title: "Error",
                message: "An error occurred while processing your request. Please try again.",
                type: .error,
                isDismissible: true,
                onDismiss: { print("Dismissed") }
            )

            InfoBox(
                message: "Simple info message without a title.",
                type: .info
            )
        }
        .padding()
    }
}
