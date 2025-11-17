import SwiftUI

public struct AnimatedCheckmark: View {
    @State private var isAnimating = false
    let color: Color
    let size: CGFloat

    public init(color: Color = .green, size: CGFloat = 60) {
        self.color = color
        self.size = size
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.3), lineWidth: size / 10)
                .frame(width: size, height: size)

            Circle()
                .trim(from: 0, to: isAnimating ? 1 : 0)
                .stroke(color, style: StrokeStyle(lineWidth: size / 10, lineCap: .round))
                .frame(width: size, height: size)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: isAnimating)

            Image(systemName: "checkmark")
                .font(.system(size: size / 2, weight: .bold))
                .foregroundColor(color)
                .scaleEffect(isAnimating ? 1 : 0)
                .animation(.spring(response: 0.5, dampingFraction: 0.6).delay(0.3), value: isAnimating)
        }
        .onAppear {
            isAnimating = true
        }
    }
}

#Preview {
    struct AnimatedCheckmarkPreview: View {
        @State private var showCheckmark = false

        var body: some View {
            VStack(spacing: 40) {
                if showCheckmark {
                    VStack(spacing: 16) {
                        AnimatedCheckmark(color: .green, size: 80)

                        Text("Success!")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.green)
                    }
                    .transition(.scale.combined(with: .opacity))
                }

                Button(showCheckmark ? "Reset" : "Show Success") {
                    withAnimation {
                        showCheckmark.toggle()
                    }
                }
                .buttonStyle(PrimaryButtonStyle(color: showCheckmark ? .gray : .blue))

                Divider()
                    .padding(.vertical)

                Text("Different Sizes:")
                    .font(.headline)

                HStack(spacing: 24) {
                    AnimatedCheckmark(color: .blue, size: 40)
                    AnimatedCheckmark(color: .purple, size: 60)
                    AnimatedCheckmark(color: .orange, size: 80)
                }
            }
            .padding()
        }
    }

    return AnimatedCheckmarkPreview()
}
