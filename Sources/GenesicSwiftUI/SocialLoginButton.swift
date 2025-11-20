import SwiftUI
import AuthenticationServices

public struct SocialLoginButton: View {
    let provider: SocialProvider
    let action: () -> Void

    public init(provider: SocialProvider, action: @escaping () -> Void) {
        self.provider = provider
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: provider.icon)
                    .font(.title3)
                    .foregroundColor(provider.iconColor)

                Text(provider.title)
                    .fontWeight(.medium)
                    .foregroundColor(provider.textColor)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(provider.backgroundColor)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(provider.borderColor, lineWidth: provider.borderWidth)
            )
        }
        .buttonStyle(LabelButtonStyle())
    }

    public enum SocialProvider {
        case google
        case facebook
        case twitter
        case github
        case custom(icon: String, title: String, backgroundColor: Color, textColor: Color)

        var icon: String {
            switch self {
            case .google: return "g.circle.fill"
            case .facebook: return "f.circle.fill"
            case .twitter: return "bird.fill"
            case .github: return "link.circle.fill"
            case .custom(let icon, _, _, _): return icon
            }
        }

        var title: String {
            switch self {
            case .google: return "Continue with Google"
            case .facebook: return "Continue with Facebook"
            case .twitter: return "Continue with Twitter"
            case .github: return "Continue with GitHub"
            case .custom(_, let title, _, _): return title
            }
        }

        var backgroundColor: Color {
            switch self {
            case .google: return .white
            case .facebook: return Color(red: 24/255, green: 119/255, blue: 242/255)
            case .twitter: return Color(red: 29/255, green: 161/255, blue: 242/255)
            case .github: return Color(red: 36/255, green: 41/255, blue: 47/255)
            case .custom(_, _, let bgColor, _): return bgColor
            }
        }

        var textColor: Color {
            switch self {
            case .google: return .black
            case .facebook, .twitter, .github: return .white
            case .custom(_, _, _, let textColor): return textColor
            }
        }

        var iconColor: Color {
            switch self {
            case .google: return .black
            case .facebook, .twitter, .github: return .white
            case .custom(_, _, _, let textColor): return textColor
            }
        }

        var borderColor: Color {
            switch self {
            case .google: return Color(.separator)
            case .facebook, .twitter, .github: return .clear
            case .custom: return .clear
            }
        }

        var borderWidth: CGFloat {
            switch self {
            case .google: return 1
            case .facebook, .twitter, .github: return 0
            case .custom: return 0
            }
        }
    }
}

public struct CompactLoginView: View {
    @Binding var email: String
    @Binding var password: String
    let onLogin: () -> Void
    let socialProviders: [SocialLoginButton.SocialProvider]
    let onSocialLogin: (SocialLoginButton.SocialProvider) -> Void

    public init(
        email: Binding<String>,
        password: Binding<String>,
        onLogin: @escaping () -> Void,
        socialProviders: [SocialLoginButton.SocialProvider] = [.google],
        onSocialLogin: @escaping (SocialLoginButton.SocialProvider) -> Void
    ) {
        self._email = email
        self._password = password
        self.onLogin = onLogin
        self.socialProviders = socialProviders
        self.onSocialLogin = onSocialLogin
    }

    public var body: some View {
        VStack(spacing: 20) {
            // Email & Password
            VStack(spacing: 12) {
                TextField("Email", text: $email)
                    .textFieldStyle(.roundedBorder)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)

                SecureField("Password", text: $password)
                    .textFieldStyle(.roundedBorder)
            }

            // Login Button
            Button("Sign In") {
                onLogin()
            }
            .buttonStyle(PrimaryButtonStyle(isFullWidth: true))

            // Social Login Options
            if !socialProviders.isEmpty {
                VStack(spacing: 12) {
                    ForEach(socialProviders.indices, id: \.self) { index in
                        SocialLoginButton(provider: socialProviders[index]) {
                            onSocialLogin(socialProviders[index])
                        }
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Social Login Buttons")
                    .font(.title2)
                    .fontWeight(.bold)

                VStack(spacing: 12) {
                    SocialLoginButton(provider: .google) {
                        print("Google")
                    }

                    SocialLoginButton(provider: .facebook) {
                        print("Facebook")
                    }

                    SocialLoginButton(provider: .twitter) {
                        print("Twitter")
                    }

                    SocialLoginButton(provider: .github) {
                        print("GitHub")
                    }

                    SocialLoginButton(
                        provider: .custom(
                            icon: "microsoft.logo",
                            title: "Continue with Microsoft",
                            backgroundColor: Color(red: 0/255, green: 120/255, blue: 212/255),
                            textColor: .white
                        )
                    ) {
                        print("Microsoft")
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 16) {
                Text("Compact Login View")
                    .font(.title2)
                    .fontWeight(.bold)

                CompactLoginView(
                    email: .constant(""),
                    password: .constant(""),
                    onLogin: {
                        print("Login")
                    },
                    socialProviders: [.google, .facebook],
                    onSocialLogin: { provider in
                        print("Social login: \(provider)")
                    }
                )
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}
