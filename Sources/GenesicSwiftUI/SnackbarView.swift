import SwiftUI

public struct SnackbarView: View {
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?

    public init(
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.message = message
        self.actionTitle = actionTitle
        self.action = action
    }

    public var body: some View {
        HStack {
            Text(message)
                .font(.subheadline)
                .foregroundColor(.white)
                .lineLimit(2)

            Spacer()

            if let actionTitle = actionTitle, let action = action {
                Button(action: action) {
                    Text(actionTitle)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)
                }
                .buttonStyle(LabelButtonStyle())
            }
        }
        .padding()
        .background(Color(.darkGray))
        .cornerRadius(8)
        .padding(.horizontal)
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
    }
}

public struct SnackbarModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let actionTitle: String?
    let action: (() -> Void)?
    let duration: TimeInterval

    public func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    Spacer()
                    SnackbarView(
                        message: message,
                        actionTitle: actionTitle,
                        action: action
                    )
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                        withAnimation {
                            isPresented = false
                        }
                    }
                }
            }
        }
        .animation(.spring(), value: isPresented)
    }
}

public extension View {
    func snackbar(
        isPresented: Binding<Bool>,
        message: String,
        actionTitle: String? = nil,
        action: (() -> Void)? = nil,
        duration: TimeInterval = 4.0
    ) -> some View {
        modifier(SnackbarModifier(
            isPresented: isPresented,
            message: message,
            actionTitle: actionTitle,
            action: action,
            duration: duration
        ))
    }
}

#Preview {
    struct SnackbarPreview: View {
        @State private var showSnackbar1 = false
        @State private var showSnackbar2 = false

        var body: some View {
            VStack(spacing: 20) {
                Button("Show Simple Snackbar") {
                    showSnackbar1 = true
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Show Snackbar with Action") {
                    showSnackbar2 = true
                }
                .buttonStyle(PrimaryButtonStyle(color: .green))

                Spacer()

                Text("Preview:")
                    .font(.headline)

                SnackbarView(message: "Item deleted")

                SnackbarView(
                    message: "Message sent successfully",
                    actionTitle: "UNDO",
                    action: { print("Undo") }
                )
            }
            .padding()
            .snackbar(isPresented: $showSnackbar1, message: "Connection established")
            .snackbar(
                isPresented: $showSnackbar2,
                message: "File deleted",
                actionTitle: "UNDO",
                action: { print("Undo tapped") }
            )
        }
    }

    return SnackbarPreview()
}
