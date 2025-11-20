import SwiftUI

public struct StepperControl: View {
    @Binding var value: Int
    let range: ClosedRange<Int>
    let label: String?
    let color: Color

    public init(
        value: Binding<Int>,
        range: ClosedRange<Int> = 0...100,
        label: String? = nil,
        color: Color = .blue
    ) {
        self._value = value
        self.range = range
        self.label = label
        self.color = color
    }

    public var body: some View {
        HStack(spacing: 16) {
            if let label = label {
                Text(label)
                    .font(.body)
                Spacer()
            }

            HStack(spacing: 0) {
                Button(action: decrement) {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(value > range.lowerBound ? color : .secondary)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                }
                .buttonStyle(LabelButtonStyle())
                .disabled(value <= range.lowerBound)

                Text("\(value)")
                    .font(.body)
                    .fontWeight(.semibold)
                    .frame(minWidth: 40)

                Button(action: increment) {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(value < range.upperBound ? color : .secondary)
                        .frame(width: 40, height: 40)
                        .background(Color(.systemGray6))
                }
                .buttonStyle(LabelButtonStyle())
                .disabled(value >= range.upperBound)
            }
            .background(Color(.systemGray6))
            .cornerRadius(8)
        }
    }

    private func increment() {
        if value < range.upperBound {
            value += 1
        }
    }

    private func decrement() {
        if value > range.lowerBound {
            value -= 1
        }
    }
}

#Preview {
    struct StepperControlPreview: View {
        @State private var quantity = 1
        @State private var guests = 2
        @State private var items = 5

        var body: some View {
            VStack(spacing: 24) {
                StepperControl(
                    value: $quantity,
                    range: 0...10,
                    label: "Quantity"
                )

                StepperControl(
                    value: $guests,
                    range: 1...20,
                    label: "Number of Guests",
                    color: .green
                )

                StepperControl(
                    value: $items,
                    range: 0...100,
                    label: "Items",
                    color: .purple
                )

                Divider()

                Text("Quantity: \(quantity)")
                Text("Guests: \(guests)")
                Text("Items: \(items)")
            }
            .padding()
        }
    }

    return StepperControlPreview()
}
