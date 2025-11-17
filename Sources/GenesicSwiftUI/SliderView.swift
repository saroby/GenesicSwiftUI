import SwiftUI

public struct SliderView: View {
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double?
    let label: String?
    let showValue: Bool
    let color: Color

    public init(
        value: Binding<Double>,
        range: ClosedRange<Double> = 0...100,
        step: Double? = nil,
        label: String? = nil,
        showValue: Bool = true,
        color: Color = .blue
    ) {
        self._value = value
        self.range = range
        self.step = step
        self.label = label
        self.showValue = showValue
        self.color = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                if let label = label {
                    Text(label)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }

                Spacer()

                if showValue {
                    Text(valueText)
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
            }

            if let step = step {
                Slider(value: $value, in: range, step: step)
                    .tint(color)
            } else {
                Slider(value: $value, in: range)
                    .tint(color)
            }

            HStack {
                Text("\(Int(range.lowerBound))")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                Text("\(Int(range.upperBound))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    private var valueText: String {
        if let step = step, step >= 1 {
            return "\(Int(value))"
        } else {
            return String(format: "%.1f", value)
        }
    }
}

#Preview {
    struct SliderViewPreview: View {
        @State private var volume: Double = 50
        @State private var brightness: Double = 75
        @State private var temperature: Double = 20.5

        var body: some View {
            VStack(spacing: 32) {
                SliderView(
                    value: $volume,
                    range: 0...100,
                    step: 1,
                    label: "Volume",
                    color: .blue
                )

                SliderView(
                    value: $brightness,
                    range: 0...100,
                    step: 5,
                    label: "Brightness",
                    color: .orange
                )

                SliderView(
                    value: $temperature,
                    range: 15...30,
                    label: "Temperature (°C)",
                    color: .red
                )
            }
            .padding()
        }
    }

    return SliderViewPreview()
}
