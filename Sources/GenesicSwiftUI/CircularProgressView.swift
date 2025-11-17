import SwiftUI

public struct CircularProgressView: View {
    let progress: Double
    let lineWidth: CGFloat
    let color: Color
    let showPercentage: Bool

    public init(
        progress: Double,
        lineWidth: CGFloat = 10,
        color: Color = .blue,
        showPercentage: Bool = true
    ) {
        self.progress = min(max(progress, 0), 1)
        self.lineWidth = lineWidth
        self.color = color
        self.showPercentage = showPercentage
    }

    public var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.5), value: progress)

            if showPercentage {
                Text("\(Int(progress * 100))%")
                    .font(.title3)
                    .fontWeight(.semibold)
            }
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        HStack(spacing: 32) {
            VStack(spacing: 8) {
                CircularProgressView(progress: 0.25, color: .blue)
                    .frame(width: 80, height: 80)
                Text("25%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 8) {
                CircularProgressView(progress: 0.5, color: .green)
                    .frame(width: 80, height: 80)
                Text("50%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            VStack(spacing: 8) {
                CircularProgressView(progress: 0.75, color: .orange)
                    .frame(width: 80, height: 80)
                Text("75%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }

        HStack(spacing: 32) {
            CircularProgressView(progress: 0.9, lineWidth: 15, color: .purple)
                .frame(width: 120, height: 120)

            CircularProgressView(progress: 0.65, lineWidth: 20, color: .red)
                .frame(width: 120, height: 120)
        }

        CircularProgressView(
            progress: 0.85,
            lineWidth: 25,
            color: .pink,
            showPercentage: true
        )
        .frame(width: 150, height: 150)
    }
    .padding()
}
