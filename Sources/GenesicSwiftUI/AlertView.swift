import SwiftUI

public struct AlertView: View {
    let title: String
    let message: String
    let icon: String?
    let iconColor: Color
    let primaryButton: AlertButton
    let secondaryButton: AlertButton?

    public init(
        title: String,
        message: String,
        icon: String? = nil,
        iconColor: Color = .blue,
        primaryButton: AlertButton,
        secondaryButton: AlertButton? = nil
    ) {
        self.title = title
        self.message = message
        self.icon = icon
        self.iconColor = iconColor
        self.primaryButton = primaryButton
        self.secondaryButton = secondaryButton
    }

    public var body: some View {
        VStack(spacing: 20) {
            if let icon = icon {
                Image(systemName: icon)
                    .font(.system(size: 50))
                    .foregroundColor(iconColor)
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)

                Text(message)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }

            VStack(spacing: 12) {
                Button(action: primaryButton.action) {
                    Text(primaryButton.title)
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(primaryButton.color)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(LabelButtonStyle())

                if let secondaryButton = secondaryButton {
                    Button(action: secondaryButton.action) {
                        Text(secondaryButton.title)
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Color(.systemGray6))
                            .foregroundColor(.primary)
                            .cornerRadius(10)
                    }
                    .buttonStyle(LabelButtonStyle())
                }
            }
        }
        .padding(24)
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 10)
        .padding(.horizontal, 40)
    }
}

public struct AlertButton {
    let title: String
    let color: Color
    let action: () -> Void

    public init(title: String, color: Color = .blue, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.action = action
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.3)
            .ignoresSafeArea()

        VStack(spacing: 30) {
            AlertView(
                title: "Delete Item",
                message: "Are you sure you want to delete this item? This action cannot be undone.",
                icon: "trash.fill",
                iconColor: .red,
                primaryButton: AlertButton(title: "Delete", color: .red) {
                    print("Deleted")
                },
                secondaryButton: AlertButton(title: "Cancel", color: .gray) {
                    print("Cancelled")
                }
            )

            AlertView(
                title: "Success",
                message: "Your changes have been saved successfully!",
                icon: "checkmark.circle.fill",
                iconColor: .green,
                primaryButton: AlertButton(title: "OK", color: .green) {
                    print("OK")
                }
            )
        }
    }
}
