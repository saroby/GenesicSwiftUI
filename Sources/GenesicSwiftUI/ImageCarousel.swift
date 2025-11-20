import SwiftUI

public struct ImageCarousel: View {
    let imageURLs: [URL]
    @State private var currentIndex = 0
    let autoScroll: Bool
    let interval: TimeInterval
    @State private var timer: Timer?

    public init(
        imageURLs: [URL],
        autoScroll: Bool = false,
        interval: TimeInterval = 3.0
    ) {
        self.imageURLs = imageURLs
        self.autoScroll = autoScroll
        self.interval = interval
    }

    public var body: some View {
        VStack(spacing: 12) {
            TabView(selection: $currentIndex) {
                ForEach(0..<imageURLs.count, id: \.self) { index in
                    AsyncImage(url: imageURLs[index]) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Rectangle()
                                .fill(Color(.systemGray5))
                                .overlay(
                                    Image(systemName: "photo")
                                        .font(.largeTitle)
                                        .foregroundColor(.secondary)
                                )
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 12))

            // Custom page indicator
            HStack(spacing: 8) {
                ForEach(0..<imageURLs.count, id: \.self) { index in
                    Circle()
                        .fill(index == currentIndex ? Color.blue : Color(.systemGray4))
                        .frame(width: 8, height: 8)
                        .onTapGesture {
                            currentIndex = index
                        }
                }
            }
        }
        .onAppear {
            if autoScroll {
                startAutoScroll()
            }
        }
        .onDisappear {
            stopAutoScroll()
        }
    }

    private func startAutoScroll() {
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            withAnimation {
                currentIndex = (currentIndex + 1) % imageURLs.count
            }
        }
    }

    private func stopAutoScroll() {
        timer?.invalidate()
        timer = nil
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 12) {
                Text("Manual Scroll")
                    .font(.headline)

                ImageCarousel(
                    imageURLs: [
                        URL(string: "https://picsum.photos/400/250?random=1")!,
                        URL(string: "https://picsum.photos/400/250?random=2")!,
                        URL(string: "https://picsum.photos/400/250?random=3")!,
                        URL(string: "https://picsum.photos/400/250?random=4")!
                    ]
                )
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Auto Scroll")
                    .font(.headline)

                ImageCarousel(
                    imageURLs: [
                        URL(string: "https://picsum.photos/400/250?random=5")!,
                        URL(string: "https://picsum.photos/400/250?random=6")!,
                        URL(string: "https://picsum.photos/400/250?random=7")!
                    ],
                    autoScroll: true,
                    interval: 2.0
                )
            }
        }
        .padding()
    }
}
