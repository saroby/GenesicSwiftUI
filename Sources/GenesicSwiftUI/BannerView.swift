import SwiftUI

public struct BannerView: View {
    let title: String
    let message: String?
    let style: ToastStyle
    let showCloseButton: Bool
    let onClose: (() -> Void)?

    public init(
        title: String,
        message: String? = nil,
        style: ToastStyle = .info,
        showCloseButton: Bool = true,
        onClose: (() -> Void)? = nil
    ) {
        self.title = title
        self.message = message
        self.style = style
        self.showCloseButton = showCloseButton
        self.onClose = onClose
    }

    public var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: style.icon)
                .font(.title3)
                .foregroundColor(style.color)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.semibold)

                if let message = message {
                    Text(message)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            if showCloseButton {
                Button(action: {
                    onClose?()
                }) {
                    Image(systemName: "xmark")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .buttonStyle(LabelButtonStyle())
            }
        }
        .padding()
        .background(style.color.opacity(0.15))
        .cornerRadius(8)
    }
}

#Preview {
    VStack(spacing: 16) {
        BannerView(
            title: "Success",
            message: "Your changes have been saved successfully.",
            style: .success
        ) {
            print("Close tapped")
        }

        BannerView(
            title: "Error",
            message: "Unable to connect to the server. Please check your internet connection.",
            style: .error
        ) {
            print("Close tapped")
        }

        BannerView(
            title: "Warning",
            message: "Your storage is almost full. Consider deleting some files.",
            style: .warning
        )

        BannerView(
            title: "New Update Available",
            message: "Version 2.0 is now available. Update to get the latest features.",
            style: .info,
            showCloseButton: false
        )
    }
    .padding()
}
