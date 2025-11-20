import SwiftUI

public struct EmptyStateView: View {
    let systemImage: String
    let title: String
    let description: String?
    let action: (() -> Void)?
    let actionLabel: String?

    public init(
        systemImage: String = "tray",
        title: String,
        description: String? = nil,
        actionLabel: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.systemImage = systemImage
        self.title = title
        self.description = description
        self.actionLabel = actionLabel
        self.action = action
    }

    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: systemImage)
                .font(.system(size: 60))
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                Text(title)
                    .font(.title2)
                    .fontWeight(.semibold)

                if let description = description {
                    Text(description)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }

            if let action = action, let actionLabel = actionLabel {
                Button(action: action) {
                    Text(actionLabel)
                        .fontWeight(.medium)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 8)
            }
        }
        .padding()
    }
}

#Preview {
    VStack(spacing: 50) {
        EmptyStateView(
            systemImage: "doc.text.magnifyingglass",
            title: "No Results",
            description: "We couldn't find any items matching your search."
        )

        EmptyStateView(
            systemImage: "plus.circle",
            title: "No Items",
            description: "Get started by adding your first item.",
            actionLabel: "Add Item",
            action: { print("Add tapped") }
        )
    }
}
