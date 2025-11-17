import SwiftUI

public struct SkeletonView: View {
    let cornerRadius: CGFloat
    @State private var isAnimating = false

    public init(cornerRadius: CGFloat = 8) {
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .fill(
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(.systemGray5),
                        Color(.systemGray6),
                        Color(.systemGray5)
                    ]),
                    startPoint: isAnimating ? .leading : .trailing,
                    endPoint: isAnimating ? .trailing : .leading
                )
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    isAnimating = true
                }
            }
    }
}

public struct SkeletonText: View {
    let lines: Int
    let spacing: CGFloat

    public init(lines: Int = 3, spacing: CGFloat = 8) {
        self.lines = lines
        self.spacing = spacing
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                SkeletonView()
                    .frame(height: 12)
                    .frame(maxWidth: index == lines - 1 ? .infinity : nil)
                    .frame(width: index == lines - 1 ? nil : CGFloat.random(in: 200...300))
            }
        }
    }
}

public struct SkeletonCard: View {
    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                SkeletonView()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 8) {
                    SkeletonView()
                        .frame(width: 150, height: 12)

                    SkeletonView()
                        .frame(width: 100, height: 10)
                }
            }

            SkeletonView()
                .frame(height: 200)

            SkeletonText(lines: 2)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            Text("Skeleton Components")
                .font(.title)
                .fontWeight(.bold)

            VStack(alignment: .leading, spacing: 12) {
                Text("Basic Skeleton")
                    .font(.headline)
                SkeletonView()
                    .frame(height: 100)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Skeleton Text")
                    .font(.headline)
                SkeletonText(lines: 4)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Skeleton Card")
                    .font(.headline)
                SkeletonCard()
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("List of Skeleton Cards")
                    .font(.headline)
                ForEach(0..<3, id: \.self) { _ in
                    SkeletonCard()
                }
            }
        }
        .padding()
    }
}
