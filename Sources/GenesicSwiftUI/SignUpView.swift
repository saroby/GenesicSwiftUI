import SwiftUI
import AuthenticationServices

public struct SignUpView: View {
    @Binding var fullName: String
    @Binding var email: String
    @Binding var password: String
    @Binding var confirmPassword: String
    @Binding var agreedToTerms: Bool

    let onSignUp: () -> Void
    let onAppleSignUp: () -> Void
    let onGoogleSignUp: () -> Void
    let onSignIn: (() -> Void)?

    @FocusState private var focusedField: Field?

    public init(
        fullName: Binding<String>,
        email: Binding<String>,
        password: Binding<String>,
        confirmPassword: Binding<String>,
        agreedToTerms: Binding<Bool>,
        onSignUp: @escaping () -> Void,
        onAppleSignUp: @escaping () -> Void,
        onGoogleSignUp: @escaping () -> Void,
        onSignIn: (() -> Void)? = nil
    ) {
        self._fullName = fullName
        self._email = email
        self._password = password
        self._confirmPassword = confirmPassword
        self._agreedToTerms = agreedToTerms
        self.onSignUp = onSignUp
        self.onAppleSignUp = onAppleSignUp
        self.onGoogleSignUp = onGoogleSignUp
        self.onSignIn = onSignIn
    }

    enum Field {
        case fullName
        case email
        case password
        case confirmPassword
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Logo/Header
                VStack(spacing: 8) {
                    Image(systemName: "person.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.blue)

                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("Sign up to get started")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)

                // Input Fields
                VStack(spacing: 16) {
                    FloatingTextField(
                        text: $fullName,
                        placeholder: "Full Name",
                        icon: "person.fill"
                    )
                    .focused($focusedField, equals: .fullName)
                    .onSubmit {
                        focusedField = .email
                    }

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
                        focusedField = .confirmPassword
                    }

                    FloatingTextField(
                        text: $confirmPassword,
                        placeholder: "Confirm Password",
                        icon: "lock.fill",
                        isSecure: true
                    )
                    .focused($focusedField, equals: .confirmPassword)
                    .onSubmit {
                        if agreedToTerms {
                            onSignUp()
                        }
                    }
                }

                // Password Requirements
                VStack(alignment: .leading, spacing: 8) {
                    PasswordRequirement(
                        text: "At least 8 characters",
                        isMet: password.count >= 8
                    )
                    PasswordRequirement(
                        text: "Passwords match",
                        isMet: !password.isEmpty && password == confirmPassword
                    )
                }
                .font(.caption)
                .padding(.horizontal, 4)

                // Terms & Conditions
                CheckboxView(
                    isChecked: $agreedToTerms,
                    label: nil
                ) {
                    HStack(spacing: 4) {
                        Text("I agree to the")
                            .foregroundColor(.primary)
                        Button("Terms & Conditions") {
                            print("Show Terms")
                        }
                        .foregroundColor(.blue)
                    }
                    .font(.subheadline)
                }

                // Sign Up Button
                Button("Sign Up") {
                    onSignUp()
                }
                .buttonStyle(PrimaryButtonStyle(isFullWidth: true))
                .disabled(!agreedToTerms || email.isEmpty || password.isEmpty || fullName.isEmpty)
                .opacity((!agreedToTerms || email.isEmpty || password.isEmpty || fullName.isEmpty) ? 0.6 : 1.0)

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

                // Social Sign Up Buttons
                VStack(spacing: 12) {
                    SignInWithAppleButton(.signUp) { request in
                        request.requestedScopes = [.email, .fullName]
                    } onCompletion: { result in
                        switch result {
                        case .success:
                            onAppleSignUp()
                        case .failure(let error):
                            print("Apple Sign Up Error: \(error)")
                        }
                    }
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(10)

                    Button(action: onGoogleSignUp) {
                        HStack {
                            Image(systemName: "g.circle.fill")
                                .font(.title3)

                            Text("Sign up with Google")
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

                // Sign In Link
                if let onSignIn = onSignIn {
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(.secondary)

                        Button("Sign In") {
                            onSignIn()
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

struct PasswordRequirement: View {
    let text: String
    let isMet: Bool

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: isMet ? "checkmark.circle.fill" : "circle")
                .foregroundColor(isMet ? .green : .secondary)
                .font(.caption)

            Text(text)
                .foregroundColor(isMet ? .green : .secondary)
        }
    }
}

extension CheckboxView {
    init<Content: View>(
        isChecked: Binding<Bool>,
        label: String? = nil,
        color: Color = .blue,
        @ViewBuilder content: () -> Content
    ) where Content: View {
        self.init(isChecked: isChecked, label: label, color: color)
        // Note: This is a simplified version. For full custom content support,
        // you might need to modify the original CheckboxView
    }
}

#Preview {
    struct SignUpPreview: View {
        @State private var fullName = ""
        @State private var email = ""
        @State private var password = ""
        @State private var confirmPassword = ""
        @State private var agreedToTerms = false

        var body: some View {
            SignUpView(
                fullName: $fullName,
                email: $email,
                password: $password,
                confirmPassword: $confirmPassword,
                agreedToTerms: $agreedToTerms,
                onSignUp: {
                    print("Sign Up with: \(fullName), \(email)")
                },
                onAppleSignUp: {
                    print("Apple Sign Up")
                },
                onGoogleSignUp: {
                    print("Google Sign Up")
                },
                onSignIn: {
                    print("Navigate to Sign In")
                }
            )
        }
    }

    return SignUpPreview()
}
