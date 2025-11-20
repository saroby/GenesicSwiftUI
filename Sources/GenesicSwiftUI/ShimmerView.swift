import SwiftUI

public struct ShimmerModifier: ViewModifier {
    @State private var phase: CGFloat = 0

    public func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(
                    gradient: Gradient(colors: [
                        .clear,
                        Color.white.opacity(0.3),
                        .clear
                    ]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.5).repeatForever(autoreverses: false)) {
                    phase = 500
                }
            }
    }
}

public extension View {
    func shimmer() -> some View {
        modifier(ShimmerModifier())
    }
}

public struct ShimmerView: View {
    public init() {}

    public var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(.systemGray5))
            .shimmer()
    }
}

#Preview {
    VStack(spacing: 24) {
        Text("Shimmer Effects")
            .font(.title)
            .fontWeight(.bold)

        VStack(alignment: .leading, spacing: 12) {
            Text("Rectangle with Shimmer")
                .font(.headline)

            ShimmerView()
                .frame(height: 100)
        }

        VStack(alignment: .leading, spacing: 12) {
            Text("Card with Shimmer")
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                HStack(spacing: 12) {
                    Circle()
                        .fill(Color(.systemGray5))
                        .frame(width: 60, height: 60)
                        .shimmer()

                    VStack(alignment: .leading, spacing: 8) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 150, height: 12)
                            .shimmer()

                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(width: 100, height: 10)
                            .shimmer()
                    }
                }

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(.systemGray5))
                    .frame(height: 200)
                    .shimmer()

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(.systemGray5))
                            .frame(height: 12)
                            .shimmer()
                    }
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }

        VStack(alignment: .leading, spacing: 12) {
            Text("Text Placeholders")
                .font(.headline)

            VStack(alignment: .leading, spacing: 8) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(.systemGray5))
                        .frame(width: index == 3 ? 200 : nil, height: 14)
                        .shimmer()
                }
            }
        }
    }
    .padding()
}
