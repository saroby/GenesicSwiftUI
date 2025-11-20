import SwiftUI

public struct CheckboxView: View {
    @Binding var isChecked: Bool
    let label: String?
    let color: Color

    public init(
        isChecked: Binding<Bool>,
        label: String? = nil,
        color: Color = .blue
    ) {
        self._isChecked = isChecked
        self.label = label
        self.color = color
    }

    public var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(isChecked ? color : Color(.systemGray3), lineWidth: 2)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(isChecked ? color : Color.clear)
                        )
                        .frame(width: 24, height: 24)

                    if isChecked {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.white)
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

public struct CheckboxGroup: View {
    @Binding var selectedItems: Set<String>
    let items: [String]
    let color: Color

    public init(
        selectedItems: Binding<Set<String>>,
        items: [String],
        color: Color = .blue
    ) {
        self._selectedItems = selectedItems
        self.items = items
        self.color = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(items, id: \.self) { item in
                CheckboxView(
                    isChecked: Binding(
                        get: { selectedItems.contains(item) },
                        set: { isChecked in
                            if isChecked {
                                selectedItems.insert(item)
                            } else {
                                selectedItems.remove(item)
                            }
                        }
                    ),
                    label: item,
                    color: color
                )
            }
        }
    }
}

#Preview {
    struct CheckboxPreview: View {
        @State private var agreedToTerms = false
        @State private var subscribeNewsletter = true
        @State private var selectedFeatures: Set<String> = ["Feature 2"]

        var body: some View {
            VStack(alignment: .leading, spacing: 32) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Individual Checkboxes")
                        .font(.headline)

                    CheckboxView(isChecked: $agreedToTerms, label: "I agree to Terms & Conditions")
                    CheckboxView(isChecked: $subscribeNewsletter, label: "Subscribe to newsletter", color: .green)
                }

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Checkbox Group")
                        .font(.headline)

                    CheckboxGroup(
                        selectedItems: $selectedFeatures,
                        items: ["Feature 1", "Feature 2", "Feature 3", "Feature 4"],
                        color: .purple
                    )

                    Text("Selected: \(selectedFeatures.joined(separator: ", "))")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }

    return CheckboxPreview()
}
