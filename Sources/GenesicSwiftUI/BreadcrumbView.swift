import SwiftUI

public struct BreadcrumbView: View {
    let items: [String]
    let separator: String
    let onTap: ((Int) -> Void)?

    public init(
        items: [String],
        separator: String = ">",
        onTap: ((Int) -> Void)? = nil
    ) {
        self.items = items
        self.separator = separator
        self.onTap = onTap
    }

    public var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(0..<items.count, id: \.self) { index in
                    Button(action: {
                        onTap?(index)
                    }) {
                        Text(items[index])
                            .font(.subheadline)
                            .foregroundColor(index == items.count - 1 ? .primary : .blue)
                    }
                    .buttonStyle(LabelButtonStyle())
                    .disabled(index == items.count - 1)

                    if index < items.count - 1 {
                        Text(separator)
                            .foregroundColor(.secondary)
                            .font(.subheadline)
                    }
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        VStack(alignment: .leading, spacing: 12) {
            Text("Default Breadcrumb")
                .font(.headline)

            BreadcrumbView(
                items: ["Home", "Products", "Electronics", "Smartphones"]
            ) { index in
                print("Tapped: \(index)")
            }
        }

        VStack(alignment: .leading, spacing: 12) {
            Text("Custom Separator")
                .font(.headline)

            BreadcrumbView(
                items: ["Documents", "Projects", "2024", "Reports"],
                separator: "/"
            )
        }

        VStack(alignment: .leading, spacing: 12) {
            Text("Long Path")
                .font(.headline)

            BreadcrumbView(
                items: ["Root", "Users", "Admin", "Documents", "Work", "Projects", "Current", "File.txt"],
                separator: "•"
            )
        }
    }
    .padding()
}
