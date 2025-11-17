import SwiftUI

public struct ListItemView: View {
    let title: String
    let subtitle: String?
    let icon: String?
    let iconColor: Color
    let trailing: ListItemTrailing?
    let action: (() -> Void)?

    public init(
        title: String,
        subtitle: String? = nil,
        icon: String? = nil,
        iconColor: Color = .blue,
        trailing: ListItemTrailing? = .chevron,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.iconColor = iconColor
        self.trailing = trailing
        self.action = action
    }

    public var body: some View {
        Button(action: {
            action?()
        }) {
            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title3)
                        .foregroundColor(iconColor)
                        .frame(width: 32)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.body)
                        .foregroundColor(.primary)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if let trailing = trailing {
                    trailingView(for: trailing)
                }
            }
            .padding()
            .background(Color(.systemBackground))
        }
        .buttonStyle(LabelButtonStyle())
    }

    @ViewBuilder
    private func trailingView(for type: ListItemTrailing) -> some View {
        switch type {
        case .chevron:
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.secondary)
        case .text(let text):
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
        case .badge(let count):
            Text("\(count)")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Circle().fill(Color.red))
        case .toggle(let isOn):
            Toggle("", isOn: isOn)
                .labelsHidden()
        case .icon(let iconName, let color):
            Image(systemName: iconName)
                .foregroundColor(color)
        }
    }

    public enum ListItemTrailing {
        case chevron
        case text(String)
        case badge(Int)
        case toggle(Binding<Bool>)
        case icon(String, Color)
    }
}

#Preview {
    struct ListItemPreview: View {
        @State private var notificationsEnabled = true
        @State private var darkModeEnabled = false

        var body: some View {
            List {
                Section("Navigation") {
                    ListItemView(
                        title: "Profile",
                        subtitle: "View and edit your profile",
                        icon: "person.circle.fill",
                        iconColor: .blue
                    ) {
                        print("Profile tapped")
                    }

                    ListItemView(
                        title: "Settings",
                        icon: "gearshape.fill",
                        iconColor: .gray
                    ) {
                        print("Settings tapped")
                    }
                }

                Section("With Text Trailing") {
                    ListItemView(
                        title: "Language",
                        icon: "globe",
                        iconColor: .green,
                        trailing: .text("English")
                    )

                    ListItemView(
                        title: "Version",
                        icon: "info.circle.fill",
                        iconColor: .purple,
                        trailing: .text("2.0.1")
                    )
                }

                Section("With Badge") {
                    ListItemView(
                        title: "Messages",
                        subtitle: "You have new messages",
                        icon: "message.fill",
                        iconColor: .blue,
                        trailing: .badge(5)
                    )

                    ListItemView(
                        title: "Notifications",
                        icon: "bell.fill",
                        iconColor: .red,
                        trailing: .badge(12)
                    )
                }

                Section("With Toggle") {
                    ListItemView(
                        title: "Enable Notifications",
                        subtitle: "Receive push notifications",
                        icon: "bell.badge.fill",
                        iconColor: .orange,
                        trailing: .toggle($notificationsEnabled)
                    )

                    ListItemView(
                        title: "Dark Mode",
                        icon: "moon.fill",
                        iconColor: .indigo,
                        trailing: .toggle($darkModeEnabled)
                    )
                }

                Section("With Icon Trailing") {
                    ListItemView(
                        title: "Verified Account",
                        icon: "checkmark.seal.fill",
                        iconColor: .blue,
                        trailing: .icon("checkmark.circle.fill", .green)
                    )
                }
            }
        }
    }

    return ListItemPreview()
}
