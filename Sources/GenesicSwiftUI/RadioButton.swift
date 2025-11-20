import SwiftUI

public struct RadioButton<T: Hashable>: View {
    @Binding var selectedValue: T
    let value: T
    let label: String?
    let color: Color

    public init(
        selectedValue: Binding<T>,
        value: T,
        label: String? = nil,
        color: Color = .blue
    ) {
        self._selectedValue = selectedValue
        self.value = value
        self.label = label
        self.color = color
    }

    private var isSelected: Bool {
        selectedValue == value
    }

    public var body: some View {
        Button(action: {
            selectedValue = value
        }) {
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .strokeBorder(isSelected ? color : Color(.systemGray3), lineWidth: 2)
                        .frame(width: 24, height: 24)

                    if isSelected {
                        Circle()
                            .fill(color)
                            .frame(width: 12, height: 12)
                    }
                }

                if let label = label {
                    Text(label)
                        .font(.body)
                        .foregroundColor(.primary)
                }
            }
        }
        .buttonStyle(LabelButtonStyle())
    }
}

public struct RadioButtonGroup<T: Hashable>: View {
    @Binding var selectedValue: T
    let options: [(value: T, label: String)]
    let color: Color

    public init(
        selectedValue: Binding<T>,
        options: [(value: T, label: String)],
        color: Color = .blue
    ) {
        self._selectedValue = selectedValue
        self.options = options
        self.color = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(0..<options.count, id: \.self) { index in
                RadioButton(
                    selectedValue: $selectedValue,
                    value: options[index].value,
                    label: options[index].label,
                    color: color
                )
            }
        }
    }
}

#Preview {
    struct RadioButtonPreview: View {
        @State private var selectedSize = "M"
        @State private var selectedPayment = "card"
        @State private var selectedTheme = 0

        var body: some View {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Select Size")
                        .font(.headline)

                    RadioButtonGroup(
                        selectedValue: $selectedSize,
                        options: [
                            ("S", "Small"),
                            ("M", "Medium"),
                            ("L", "Large"),
                            ("XL", "Extra Large")
                        ]
                    )
                }

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Payment Method")
                        .font(.headline)

                    RadioButtonGroup(
                        selectedValue: $selectedPayment,
                        options: [
                            ("card", "Credit Card"),
                            ("paypal", "PayPal"),
                            ("bank", "Bank Transfer")
                        ],
                        color: .green
                    )
                }

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Theme")
                        .font(.headline)

                    RadioButtonGroup(
                        selectedValue: $selectedTheme,
                        options: [
                            (0, "Light"),
                            (1, "Dark"),
                            (2, "Auto")
                        ],
                        color: .purple
                    )
                }
            }
            .padding()
        }
    }

    return RadioButtonPreview()
}
