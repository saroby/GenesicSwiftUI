import SwiftUI

public struct SplitView<Sidebar: View, Detail: View>: View {
    let sidebar: Sidebar
    let detail: Detail
    let sidebarWidth: CGFloat

    public init(
        sidebarWidth: CGFloat = 250,
        @ViewBuilder sidebar: () -> Sidebar,
        @ViewBuilder detail: () -> Detail
    ) {
        self.sidebarWidth = sidebarWidth
        self.sidebar = sidebar()
        self.detail = detail()
    }

    public var body: some View {
        GeometryReader { geometry in
            HStack(spacing: 0) {
                sidebar
                    .frame(width: sidebarWidth)
                    .background(Color(.systemGray6))

                Divider()

                detail
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
    }
}

#Preview {
    SplitView(
        sidebar: {
            List {
                Section("Navigation") {
                    ForEach(0..<10, id: \.self) { index in
                        HStack {
                            Image(systemName: "folder.fill")
                                .foregroundColor(.blue)
                            Text("Item \(index + 1)")
                        }
                    }
                }
            }
            .listStyle(.sidebar)
        },
        detail: {
            VStack {
                Text("Detail View")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text("Select an item from the sidebar")
                    .foregroundColor(.secondary)

                Spacer()
            }
            .padding()
        }
    )
}
