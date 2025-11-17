import SwiftUI

public struct FloatingTextField: View {
    @Binding var text: String
    let placeholder: String
    let icon: String?
    let isSecure: Bool
    @FocusState private var isFocused: Bool

    public init(
        text: Binding<String>,
        placeholder: String,
        icon: String? = nil,
        isSecure: Bool = false
    ) {
        self._text = text
        self.placeholder = placeholder
        self.icon = icon
        self.isSecure = isSecure
    }

    private var showFloatingLabel: Bool {
        !text.isEmpty || isFocused
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if showFloatingLabel {
                Text(placeholder)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .transition(.opacity)
            }

            HStack(spacing: 12) {
                if let icon = icon {
                    Image(systemName: icon)
                        .foregroundColor(.secondary)
                }

                if isSecure {
                    SecureField(showFloatingLabel ? "" : placeholder, text: $text)
                        .focused($isFocused)
                } else {
                    TextField(showFloatingLabel ? "" : placeholder, text: $text)
                        .focused($isFocused)
                }
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(isFocused ? Color.blue : Color.clear, lineWidth: 2)
            )
        }
        .animation(.easeInOut(duration: 0.2), value: showFloatingLabel)
    }
}

#Preview {
    struct FloatingTextFieldPreview: View {
        @State private var name = ""
        @State private var email = ""
        @State private var password = ""

        var body: some View {
            VStack(spacing: 24) {
                FloatingTextField(text: $name, placeholder: "Name", icon: "person.fill")

                FloatingTextField(text: $email, placeholder: "Email", icon: "envelope.fill")

                FloatingTextField(text: $password, placeholder: "Password", icon: "lock.fill", isSecure: true)
            }
            .padding()
        }
    }

    return FloatingTextFieldPreview()
}
