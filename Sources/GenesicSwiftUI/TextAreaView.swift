import SwiftUI

public struct TextAreaView: View {
    @Binding var text: String
    let placeholder: String
    let minHeight: CGFloat
    let maxLength: Int?
    let showCharacterCount: Bool

    public init(
        text: Binding<String>,
        placeholder: String = "Enter text...",
        minHeight: CGFloat = 100,
        maxLength: Int? = nil,
        showCharacterCount: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.minHeight = minHeight
        self.maxLength = maxLength
        self.showCharacterCount = showCharacterCount
    }

    public var body: some View {
        VStack(alignment: .trailing, spacing: 8) {
            ZStack(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundColor(.secondary)
                        .padding(.top, 8)
                        .padding(.leading, 4)
                }

                TextEditor(text: $text)
                    .frame(minHeight: minHeight)
                    .scrollContentBackground(.hidden)
                    .onChange(of: text) { oldValue, newValue in
                        if let maxLength = maxLength, newValue.count > maxLength {
                            text = String(newValue.prefix(maxLength))
                        }
                    }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)

            if showCharacterCount {
                HStack(spacing: 4) {
                    Text("\(text.count)")
                        .foregroundColor(isOverLimit ? .red : .secondary)
                    if let maxLength = maxLength {
                        Text("/ \(maxLength)")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.caption)
            }
        }
    }

    private var isOverLimit: Bool {
        if let maxLength = maxLength {
            return text.count > maxLength
        }
        return false
    }
}

#Preview {
    struct TextAreaPreview: View {
        @State private var text1 = ""
        @State private var text2 = "Some initial text"
        @State private var text3 = ""

        var body: some View {
            ScrollView {
                VStack(spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Basic TextArea")
                            .font(.headline)
                        TextAreaView(text: $text1)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("With Initial Value")
                            .font(.headline)
                        TextAreaView(text: $text2, minHeight: 120)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("With Character Count (Max 100)")
                            .font(.headline)
                        TextAreaView(
                            text: $text3,
                            placeholder: "Enter your message...",
                            maxLength: 100,
                            showCharacterCount: true
                        )
                    }
                }
                .padding()
            }
        }
    }

    return TextAreaPreview()
}
