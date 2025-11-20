import SwiftUI

public enum ToastStyle {
    case success
    case error
    case warning
    case info

    var color: Color {
        switch self {
        case .success: return .green
        case .error: return .red
        case .warning: return .orange
        case .info: return .blue
        }
    }

    var icon: String {
        switch self {
        case .success: return "checkmark.circle.fill"
        case .error: return "xmark.circle.fill"
        case .warning: return "exclamationmark.triangle.fill"
        case .info: return "info.circle.fill"
        }
    }
}

public struct ToastView: View {
    let message: String
    let style: ToastStyle

    public init(message: String, style: ToastStyle = .info) {
        self.message = message
        self.style = style
    }

    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: style.icon)
                .font(.title3)
                .foregroundColor(style.color)

            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal)
    }
}

public struct ToastModifier: ViewModifier {
    @Binding var isPresented: Bool
    let message: String
    let style: ToastStyle
    let duration: TimeInterval

    public func body(content: Content) -> some View {
        ZStack {
            content

            if isPresented {
                VStack {
                    ToastView(message: message, style: style)
                        .transition(.move(edge: .top).combined(with: .opacity))
                    Spacer()
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
    func toast(
        isPresented: Binding<Bool>,
        message: String,
        style: ToastStyle = .info,
        duration: TimeInterval = 3.0
    ) -> some View {
        modifier(ToastModifier(
            isPresented: isPresented,
            message: message,
            style: style,
            duration: duration
        ))
    }
}

#Preview {
    struct ToastPreview: View {
        @State private var showSuccess = false
        @State private var showError = false
        @State private var showWarning = false
        @State private var showInfo = false

        var body: some View {
            VStack(spacing: 20) {
                Button("Show Success Toast") {
                    showSuccess = true
                }
                .buttonStyle(PrimaryButtonStyle())

                Button("Show Error Toast") {
                    showError = true
                }
                .buttonStyle(PrimaryButtonStyle(color: .red))

                Button("Show Warning Toast") {
                    showWarning = true
                }
                .buttonStyle(PrimaryButtonStyle(color: .orange))

                Button("Show Info Toast") {
                    showInfo = true
                }
                .buttonStyle(PrimaryButtonStyle(color: .blue))

                Spacer()

                Text("Preview of all toast styles:")
                    .font(.headline)
                    .padding(.top, 40)

                VStack(spacing: 16) {
                    ToastView(message: "Operation completed successfully!", style: .success)
                    ToastView(message: "An error occurred. Please try again.", style: .error)
                    ToastView(message: "Warning: Low storage space", style: .warning)
                    ToastView(message: "New message received", style: .info)
                }
            }
            .padding()
            .toast(isPresented: $showSuccess, message: "Success! Data saved.", style: .success)
            .toast(isPresented: $showError, message: "Error! Something went wrong.", style: .error)
            .toast(isPresented: $showWarning, message: "Warning! Check your input.", style: .warning)
            .toast(isPresented: $showInfo, message: "Info: This is a notification.", style: .info)
        }
    }

    return ToastPreview()
}
