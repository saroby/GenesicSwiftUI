import SwiftUI

public struct ProgressBarView: View {
    public enum Style {
        case linear
        case rounded
        case capsule
    }

    let value: Double // 0.0 to 1.0
    let total: Double
    let color: Color
    let backgroundColor: Color
    let height: CGFloat
    let style: Style
    let showPercentage: Bool

    public init(
        value: Double,
        total: Double = 1.0,
        color: Color = .blue,
        backgroundColor: Color = Color(.systemGray5),
        height: CGFloat = 8,
        style: Style = .rounded,
        showPercentage: Bool = false
    ) {
        self.value = min(max(value, 0), total)
        self.total = total
        self.color = color
        self.backgroundColor = backgroundColor
        self.height = height
        self.style = style
        self.showPercentage = showPercentage
    }

    private var progress: Double {
        total > 0 ? value / total : 0
    }

    private var percentage: Int {
        Int(progress * 100)
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    // Background
                    backgroundShape
                        .fill(backgroundColor)
                        .frame(height: height)

                    // Progress
                    backgroundShape
                        .fill(color)
                        .frame(width: geometry.size.width * progress, height: height)
                        .animation(.easeInOut(duration: 0.3), value: progress)
                }
            }
            .frame(height: height)

            if showPercentage {
                Text("\(percentage)%")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var backgroundShape: AnyShape {
        switch style {
        case .linear:
            return AnyShape(Rectangle())
        case .rounded:
            return AnyShape(RoundedRectangle(cornerRadius: height / 2))
        case .capsule:
            return AnyShape(Capsule())
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        VStack(alignment: .leading, spacing: 8) {
            Text("Linear Style")
                .font(.headline)
            ProgressBarView(value: 0.3, style: .linear)
            ProgressBarView(value: 0.6, style: .linear, showPercentage: true)
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Rounded Style")
                .font(.headline)
            ProgressBarView(value: 0.45, color: .green, style: .rounded)
            ProgressBarView(value: 0.75, color: .green, style: .rounded, showPercentage: true)
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Capsule Style")
                .font(.headline)
            ProgressBarView(value: 0.2, color: .orange, height: 12, style: .capsule)
            ProgressBarView(value: 0.9, color: .purple, height: 16, style: .capsule, showPercentage: true)
        }

        VStack(alignment: .leading, spacing: 8) {
            Text("Custom Height")
                .font(.headline)
            ProgressBarView(value: 50, total: 100, color: .red, height: 20, style: .rounded, showPercentage: true)
        }
    }
    .padding()
}
