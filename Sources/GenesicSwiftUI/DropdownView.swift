import SwiftUI

public struct DropdownView<T: Hashable>: View {
    @Binding var selection: T
    let options: [(value: T, label: String)]
    let placeholder: String
    @State private var isExpanded = false

    public init(
        selection: Binding<T>,
        options: [(value: T, label: String)],
        placeholder: String = "Select an option"
    ) {
        self._selection = selection
        self.options = options
        self.placeholder = placeholder
    }

    private var selectedLabel: String {
        options.first(where: { $0.value == selection })?.label ?? placeholder
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    Text(selectedLabel)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "chevron.down")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
            }
            .buttonStyle(LabelButtonStyle())

            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(0..<options.count, id: \.self) { index in
                        Button(action: {
                            selection = options[index].value
                            withAnimation {
                                isExpanded = false
                            }
                        }) {
                            HStack {
                                Text(options[index].label)
                                    .foregroundColor(.primary)

                                Spacer()

                                if options[index].value == selection {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                            .padding()
                            .background(
                                options[index].value == selection ?
                                Color.blue.opacity(0.1) : Color(.systemBackground)
                            )
                        }
                        .buttonStyle(LabelButtonStyle())

                        if index < options.count - 1 {
                            Divider()
                        }
                    }
                }
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .shadow(color: .black.opacity(0.1), radius: 5)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }
}

#Preview {
    struct DropdownPreview: View {
        @State private var selectedCountry = "US"
        @State private var selectedLanguage = "en"
        @State private var selectedNumber = 1

        var body: some View {
            VStack(spacing: 32) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Country")
                        .font(.headline)

                    DropdownView(
                        selection: $selectedCountry,
                        options: [
                            ("US", "United States"),
                            ("UK", "United Kingdom"),
                            ("CA", "Canada"),
                            ("AU", "Australia"),
                            ("DE", "Germany")
                        ]
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Language")
                        .font(.headline)

                    DropdownView(
                        selection: $selectedLanguage,
                        options: [
                            ("en", "English"),
                            ("es", "Spanish"),
                            ("fr", "French"),
                            ("de", "German"),
                            ("ja", "Japanese")
                        ],
                        placeholder: "Choose a language"
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Select Number")
                        .font(.headline)

                    DropdownView(
                        selection: $selectedNumber,
                        options: [
                            (1, "One"),
                            (2, "Two"),
                            (3, "Three"),
                            (4, "Four"),
                            (5, "Five")
                        ]
                    )
                }

                Spacer()
            }
            .padding()
        }
    }

    return DropdownPreview()
}
