import SwiftUI

public struct MenuButton: View {
    let title: String
    let icon: String?
    let items: [MenuItemData]

    public init(
        title: String,
        icon: String? = nil,
        items: [MenuItemData]
    ) {
        self.title = title
        self.icon = icon
        self.items = items
    }

    public var body: some View {
        Menu {
            ForEach(items) { item in
                if item.isDivider {
                    Divider()
                } else {
                    Button(action: item.action ?? {}) {
                        Label(item.title, systemImage: item.icon ?? "")
                    }
                    .disabled(item.isDisabled)
                }
            }
        } label: {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(systemName: icon)
                }
                Text(title)
                Image(systemName: "chevron.down")
                    .font(.caption)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(Color(.systemGray6))
            .foregroundColor(.primary)
            .cornerRadius(8)
        }
    }
}

public struct MenuItemData: Identifiable {
    public let id = UUID()
    let title: String
    let icon: String?
    let action: (() -> Void)?
    let isDisabled: Bool
    let isDivider: Bool

    public init(
        title: String = "",
        icon: String? = nil,
        isDisabled: Bool = false,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.action = action
        self.isDisabled = isDisabled
        self.isDivider = false
    }

    public static var divider: MenuItemData {
        MenuItemData(title: "", icon: nil, isDisabled: false, action: nil, isDivider: true)
    }

    private init(
        title: String,
        icon: String?,
        isDisabled: Bool,
        action: (() -> Void)?,
        isDivider: Bool
    ) {
        self.title = title
        self.icon = icon
        self.action = action
        self.isDisabled = isDisabled
        self.isDivider = isDivider
    }
}

#Preview {
    VStack(spacing: 32) {
        MenuButton(
            title: "Actions",
            icon: "ellipsis.circle",
            items: [
                MenuItemData(title: "Edit", icon: "pencil") {
                    print("Edit")
                },
                MenuItemData(title: "Duplicate", icon: "doc.on.doc") {
                    print("Duplicate")
                },
                .divider,
                MenuItemData(title: "Delete", icon: "trash") {
                    print("Delete")
                }
            ]
        )

        MenuButton(
            title: "Options",
            items: [
                MenuItemData(title: "Share", icon: "square.and.arrow.up") {
                    print("Share")
                },
                MenuItemData(title: "Copy Link", icon: "link") {
                    print("Copy Link")
                },
                .divider,
                MenuItemData(title: "Report", icon: "flag") {
                    print("Report")
                },
                MenuItemData(title: "Block", icon: "hand.raised", isDisabled: true) {
                    print("Block")
                }
            ]
        )

        MenuButton(
            title: "More",
            icon: "ellipsis",
            items: [
                MenuItemData(title: "Settings", icon: "gearshape") {
                    print("Settings")
                },
                MenuItemData(title: "Help", icon: "questionmark.circle") {
                    print("Help")
                },
                MenuItemData(title: "About", icon: "info.circle") {
                    print("About")
                }
            ]
        )
    }
    .padding()
}
