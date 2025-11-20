import SwiftUI

public struct TabBarView<Content: View>: View {
    @Binding var selectedIndex: Int
    let items: [TabBarItem]
    let content: Content

    public init(
        selectedIndex: Binding<Int>,
        items: [TabBarItem],
        @ViewBuilder content: () -> Content
    ) {
        self._selectedIndex = selectedIndex
        self.items = items
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            content

            Divider()

            HStack(spacing: 0) {
                ForEach(0..<items.count, id: \.self) { index in
                    TabBarItemView(
                        item: items[index],
                        isSelected: selectedIndex == index
                    ) {
                        selectedIndex = index
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.vertical, 8)
            .background(Color(.systemBackground))
        }
    }
}

public struct TabBarItem {
    let icon: String
    let title: String
    let badge: String?

    public init(icon: String, title: String, badge: String? = nil) {
        self.icon = icon
        self.title = title
        self.badge = badge
    }
}

struct TabBarItemView: View {
    let item: TabBarItem
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                ZStack(alignment: .topTrailing) {
                    Image(systemName: item.icon)
                        .font(.system(size: 24))

                    if let badge = item.badge {
                        Text(badge)
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(4)
                            .background(Circle().fill(Color.red))
                            .offset(x: 8, y: -8)
                    }
                }

                Text(item.title)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? .blue : .secondary)
        }
        .buttonStyle(LabelButtonStyle())
    }
}

#Preview {
    struct TabBarPreview: View {
        @State private var selectedIndex = 0

        var body: some View {
            TabBarView(
                selectedIndex: $selectedIndex,
                items: [
                    TabBarItem(icon: "house.fill", title: "Home"),
                    TabBarItem(icon: "magnifyingglass", title: "Search"),
                    TabBarItem(icon: "bell.fill", title: "Notifications", badge: "3"),
                    TabBarItem(icon: "person.fill", title: "Profile")
                ]
            ) {
                VStack {
                    Text("Content for tab \(selectedIndex)")
                        .font(.title)
                    Spacer()
                }
                .padding()
            }
        }
    }

    return TabBarPreview()
}
