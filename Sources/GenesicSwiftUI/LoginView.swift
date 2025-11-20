import SwiftUI
import AuthenticationServices

public struct LoginView: View {
    @Binding var email: String
    @Binding var password: String
    let onLogin: () -> Void
    let onAppleLogin: () -> Void
    let onGoogleLogin: () -> Void
    let onForgotPassword: (() -> Void)?
    let onSignUp: (() -> Void)?

    @FocusState private var focusedField: Field?

    public init(
        email: Binding<String>,
        password: Binding<String>,
        onLogin: @escaping () -> Void,
        onAppleLogin: @escaping () -> Void,
        onGoogleLogin: @escaping () -> Void,
        onForgotPassword: (() -> Void)? = nil,
        onSignUp: (() -> Void)? = nil
    ) {
        self._email = email
        self._password = password
        self.onLogin = onLogin
        self.onAppleLogin = onAppleLogin
        self.onGoogleLogin = onGoogleLogin
        self.onForgotPassword = onForgotPassword
        self.onSignUp = onSignUp
    }

    enum Field {
        case email
        case password
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Logo/Header
                VStack(spacing: 8) {
                    Image(systemName: "lock.shield.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("Welcome Back")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Sign in to continue")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)

                // Email & Password Fields
                VStack(spacing: 16) {
                    FloatingTextField(
                        text: $email,
                        placeholder: "Email",
                        icon: "envelope.fill"
                    )
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
                    .focused($focusedField, equals: .email)
                    .onSubmit {
                        focusedField = .password
                    }

                    FloatingTextField(
                        text: $password,
                        placeholder: "Password",
                        icon: "lock.fill",
                        isSecure: true
                    )
                    .focused($focusedField, equals: .password)
                    .onSubmit {
                        onLogin()
                    }
                }

                // Forgot Password
                if let onForgotPassword = onForgotPassword {
                    HStack {
                        Spacer()
                        Button("Forgot Password?") {
                            onForgotPassword()
                        }
                        .font(.subheadline)
                        .foregroundColor(.blue)
                    }
                }

                // Login Button
                Button("Sign In") {
                    onLogin()
                }
                .buttonStyle(PrimaryButtonStyle(isFullWidth: true))
                .padding(.top, 8)

                // Divider
                HStack {
                    Rectangle()
                        .fill(Color(.separator))
                        .frame(height: 1)

                    Text("OR")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.horizontal, 12)

                    Rectangle()
                        .fill(Color(.separator))
                        .frame(height: 1)
                }
                .padding(.vertical, 8)

                // Social Login Buttons
                VStack(spacing: 12) {
                    SignInWithAppleButton(.signIn) { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        switch result {
                        case .success:
                            onAppleLogin()
                        case .failure(let error):
                            print("Apple Sign In Error: \(error)")
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(10)

                    Button(action: onGoogleLogin) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .font(.title3)

                            Text("Sign in with Google")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 50)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .strokeBorder(Color(.separator), lineWidth: 1)
                        )
                    }
                    .buttonStyle(LabelButtonStyle())
                }

                // Sign Up Link
                if let onSignUp = onSignUp {
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(.secondary)

                        Button("Sign Up") {
                            onSignUp()
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                    }
                    .font(.subheadline)
                    .padding(.top, 8)
                }
            }
            .padding()
        }
    }
}

#Preview {
    struct LoginPreview: View {
        @State private var email = ""
        @State private var password = ""

        var body: some View {
            LoginView(
                email: $email,
                password: $password,
                onLogin: {
                    print("Login with email: \(email)")
                },
                onAppleLogin: {
                    print("Apple Login")
                },
                onGoogleLogin: {
                    print("Google Login")
                },
                onForgotPassword: {
                    print("Forgot Password")
                },
                onSignUp: {
                    print("Sign Up")
                }
            )
        }
    }

    return LoginPreview()
}
