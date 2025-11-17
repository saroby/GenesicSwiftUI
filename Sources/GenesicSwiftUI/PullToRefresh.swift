import SwiftUI

public struct PullToRefresh: View {
    let coordinateSpaceName: String
    @Binding var isRefreshing: Bool
    let onRefresh: () async -> Void

    public init(
        coordinateSpaceName: String = "pullToRefresh",
        isRefreshing: Binding<Bool>,
        onRefresh: @escaping () async -> Void
    ) {
        self.coordinateSpaceName = coordinateSpaceName
        self._isRefreshing = isRefreshing
        self.onRefresh = onRefresh
    }

    public var body: some View {
        GeometryReader { geo in
            if geo.frame(in: .named(coordinateSpaceName)).midY > 50 && !isRefreshing {
                Spacer()
                    .onAppear {
                        isRefreshing = true
                        Task {
                            await onRefresh()
                            isRefreshing = false
                        }
                    }
            }

            HStack {
                Spacer()
                if isRefreshing {
                    ProgressView()
                        .padding(.top, -geo.frame(in: .named(coordinateSpaceName)).midY / 2)
                } else {
                    Image(systemName: "arrow.down")
                        .foregroundColor(.secondary)
                        .padding(.top, -geo.frame(in: .named(coordinateSpaceName)).midY / 2)
                }
                Spacer()
            }
        }
        .padding(.top, -50)
    }
}

#Preview {
    struct PullToRefreshPreview: View {
        @State private var isRefreshing = false
        @State private var items = Array(1...20)

        var body: some View {
            ScrollView {
                PullToRefresh(isRefreshing: $isRefreshing) {
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    items = Array(1...20).shuffled()
                }

                LazyVStack(spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        Text("Item \(item)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .coordinateSpace(name: "pullToRefresh")
        }
    }

    return PullToRefreshPreview()
}
