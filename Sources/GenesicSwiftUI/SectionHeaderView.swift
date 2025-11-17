import SwiftUI

public struct SectionHeaderView: View {
    let title: String
    let subtitle: String?
    let action: (() -> Void)?
    let actionTitle: String?

    public init(
        title: String,
        subtitle: String? = nil,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                if let actionTitle = actionTitle, let action = action {
                    Button(action: action) {
                        Text(actionTitle)
                            .font(.subheadline)
                            .fontWeight(.medium)
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(LabelButtonStyle())
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    VStack(spacing: 0) {
        SectionHeaderView(
            title: "Recent Items",
            subtitle: "Updated 5 minutes ago"
        )
        .padding(.horizontal)

        List(0..<5, id: \.self) { index in
            Text("Item \(index + 1)")
        }
        .frame(height: 200)

        SectionHeaderView(
            title: "Popular Products",
            actionTitle: "See All",
            action: { print("See All tapped") }
        )
        .padding(.horizontal)

        List(0..<5, id: \.self) { index in
            Text("Product \(index + 1)")
        }
        .frame(height: 200)

        SectionHeaderView(
            title: "Categories",
            subtitle: "Browse all categories",
            actionTitle: "View More",
            action: { print("View More tapped") }
        )
        .padding(.horizontal)
    }
}
