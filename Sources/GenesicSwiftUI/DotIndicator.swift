import SwiftUI

public struct DotIndicator: View {
    @State private var isAnimating = false
    let color: Color
    let size: CGFloat

    public init(color: Color = .blue, size: CGFloat = 8) {
        self.color = color
        self.size = size
    }

    public var body: some View {
        HStack(spacing: size / 2) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .scaleEffect(isAnimating ? 1 : 0.5)
                    .opacity(isAnimating ? 1 : 0.5)
                    .animation(
                        .easeInOut(duration: 0.6)
                        .repeatForever()
                        .delay(Double(index) * 0.2),
                        value: isAnimating
                    )
            }
        }
        .onAppear {
            isAnimating = true
        }
    }
}

public struct PageControlDots: View {
    let numberOfPages: Int
    @Binding var currentPage: Int
    let activeColor: Color
    let inactiveColor: Color
    let dotSize: CGFloat

    public init(
        numberOfPages: Int,
        currentPage: Binding<Int>,
        activeColor: Color = .blue,
        inactiveColor: Color = Color(.systemGray4),
        dotSize: CGFloat = 8
    ) {
        self.numberOfPages = numberOfPages
        self._currentPage = currentPage
        self.activeColor = activeColor
        self.inactiveColor = inactiveColor
        self.dotSize = dotSize
    }

    public var body: some View {
        HStack(spacing: dotSize) {
            ForEach(0..<numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? activeColor : inactiveColor)
                    .frame(
                        width: index == currentPage ? dotSize * 1.5 : dotSize,
                        height: dotSize
                    )
                    .animation(.easeInOut(duration: 0.3), value: currentPage)
                    .onTapGesture {
                        currentPage = index
                    }
            }
        }
    }
}

#Preview {
    struct DotIndicatorPreview: View {
        @State private var currentPage = 0

        var body: some View {
            VStack(spacing: 60) {
                VStack(spacing: 16) {
                    Text("Loading Indicator")
                        .font(.headline)

                    DotIndicator()
                    DotIndicator(color: .green, size: 12)
                    DotIndicator(color: .purple, size: 16)
                }

                VStack(spacing: 16) {
                    Text("Page Control")
                        .font(.headline)

                    PageControlDots(
                        numberOfPages: 5,
                        currentPage: $currentPage
                    )

                    PageControlDots(
                        numberOfPages: 7,
                        currentPage: $currentPage,
                        activeColor: .green,
                        dotSize: 10
                    )

                    PageControlDots(
                        numberOfPages: 4,
                        currentPage: $currentPage,
                        activeColor: .purple,
                        inactiveColor: .purple.opacity(0.3),
                        dotSize: 12
                    )

                    HStack(spacing: 16) {
                        Button("Previous") {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())

                        Button("Next") {
                            if currentPage < 4 {
                                currentPage += 1
                            }
                        }
                        .buttonStyle(PrimaryButtonStyle())
                    }
                }
            }
            .padding()
        }
    }

    return DotIndicatorPreview()
}
