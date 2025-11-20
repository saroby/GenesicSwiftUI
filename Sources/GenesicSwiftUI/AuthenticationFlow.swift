import SwiftUI

public struct AuthenticationFlow: View {
    @State private var currentView: AuthView = .login
    @State private var email = ""
    @State private var password = ""
    @State private var fullName = ""
    @State private var confirmPassword = ""
    @State private var agreedToTerms = false

    let onLoginSuccess: (String) -> Void
    let onSignUpSuccess: (String) -> Void

    public init(
        onLoginSuccess: @escaping (String) -> Void,
        onSignUpSuccess: @escaping (String) -> Void
    ) {
        self.onLoginSuccess = onLoginSuccess
        self.onSignUpSuccess = onSignUpSuccess
    }

    public var body: some View {
        Group {
            switch currentView {
            case .login:
                LoginView(
                    email: $email,
                    password: $password,
                    onLogin: {
                        handleEmailLogin()
                    },
                    onAppleLogin: {
                        handleAppleLogin()
                    },
                    onGoogleLogin: {
                        handleGoogleLogin()
                    },
                    onForgotPassword: {
                        currentView = .forgotPassword
                    },
                    onSignUp: {
                        currentView = .signUp
                    }
                )

            case .signUp:
                SignUpView(
                    fullName: $fullName,
                    email: $email,
                    password: $password,
                    confirmPassword: $confirmPassword,
                    agreedToTerms: $agreedToTerms,
                    onSignUp: {
                        handleEmailSignUp()
                    },
                    onAppleSignUp: {
                        handleAppleSignUp()
                    },
                    onGoogleSignUp: {
                        handleGoogleSignUp()
                    },
                    onSignIn: {
                        currentView = .login
                    }
                )

            case .forgotPassword:
                ForgotPasswordView(
                    email: $email,
                    onResetPassword: {
                        handleResetPassword()
                    },
                    onBackToLogin: {
                        currentView = .login
                    }
                )
            }
        }
        .animation(.easeInOut, value: currentView)
    }

    enum AuthView {
        case login
        case signUp
        case forgotPassword
    }

    private func handleEmailLogin() {
        print("Login with email: \(email)")
        onLoginSuccess(email)
    }

    private func handleAppleLogin() {
        print("Apple Login")
        onLoginSuccess("apple_user")
    }

    private func handleGoogleLogin() {
        print("Google Login")
        onLoginSuccess("google_user")
    }

    private func handleEmailSignUp() {
        print("Sign Up: \(fullName), \(email)")
        onSignUpSuccess(email)
    }

    private func handleAppleSignUp() {
        print("Apple Sign Up")
        onSignUpSuccess("apple_user")
    }

    private func handleGoogleSignUp() {
        print("Google Sign Up")
        onSignUpSuccess("google_user")
    }

    private func handleResetPassword() {
        print("Reset password for: \(email)")
        currentView = .login
    }
}

struct ForgotPasswordView: View {
    @Binding var email: String
    let onResetPassword: () -> Void
    let onBackToLogin: () -> Void

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(spacing: 8) {
                    Image(systemName: "key.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("Forgot Password?")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Enter your email to reset your password")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding(.top, 60)
                .padding(.bottom, 20)

                FloatingTextField(
                    text: $email,
                    placeholder: "Email",
                    icon: "envelope.fill"
                )
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)

                Button("Reset Password") {
                    onResetPassword()
                }
                .buttonStyle(PrimaryButtonStyle(isFullWidth: true))
                .padding(.top, 8)

                Button("Back to Login") {
                    onBackToLogin()
                }
                .buttonStyle(SecondaryButtonStyle(isFullWidth: true))

                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    AuthenticationFlow(
        onLoginSuccess: { email in
            print("Login success: \(email)")
        },
        onSignUpSuccess: { email in
            print("Sign up success: \(email)")
        }
    )
}
