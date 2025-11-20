import SwiftUI

public struct SearchBar: View {
    @Binding var text: String
    let placeholder: String
    let showsCancelButton: Bool
    let onCancel: (() -> Void)?
    let onCommit: (() -> Void)?

    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeholder: String = "Search...",
        showsCancelButton: Bool = false,
        onCancel: (() -> Void)? = nil,
        onCommit: (() -> Void)? = nil
    ) {
        self._text = text
        self.placeholder = placeholder
        self.showsCancelButton = showsCancelButton
        self.onCancel = onCancel
        self.onCommit = onCommit
    }

    public var body: some View {
        HStack(spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)

                TextField(placeholder, text: $text)
                    .focused($isFocused)
                    .onSubmit {
                        onCommit?()
                    }

                if !text.isEmpty {
                    Button(action: {
                        text = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                    .buttonStyle(LabelButtonStyle())
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            if showsCancelButton && isFocused {
                Button("Cancel") {
                    text = ""
                    isFocused = false
                    onCancel?()
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: isFocused)
    }
}

#Preview {
    struct SearchBarPreview: View {
        @State private var searchText1 = ""
        @State private var searchText2 = ""
        @State private var searchText3 = ""

        var body: some View {
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Basic Search Bar")
                        .font(.headline)

                    SearchBar(text: $searchText1)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("With Cancel Button")
                        .font(.headline)

                    SearchBar(
                        text: $searchText2,
                        showsCancelButton: true,
                        onCancel: {
                            print("Cancelled")
                        }
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Custom Placeholder with Commit")
                        .font(.headline)

                    SearchBar(
                        text: $searchText3,
                        placeholder: "Search for items...",
                        showsCancelButton: true,
                        onCommit: {
                            print("Search: \(searchText3)")
                        }
                    )
                }

                if !searchText1.isEmpty {
                    Text("Searching for: \(searchText1)")
                        .foregroundColor(.secondary)
                }
            }
            .padding()
        }
    }

    return SearchBarPreview()
}
