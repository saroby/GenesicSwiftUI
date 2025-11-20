import SwiftUI

public struct GradientButton: View {
    let title: String
    let gradient: LinearGradient
    let action: () -> Void

    public init(
        title: String,
        gradient: LinearGradient,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.gradient = gradient
        self.action = action
    }

    public init(
        title: String,
        colors: [Color],
        action: @escaping () -> Void
    ) {
        self.title = title
        self.gradient = LinearGradient(
            colors: colors,
            startPoint: .leading,
            endPoint: .trailing
        )
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(gradient)
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 3)
        }
        .buttonStyle(LabelButtonStyle())
    }
}

#Preview {
    VStack(spacing: 24) {
        GradientButton(
            title: "Blue Gradient",
            colors: [.blue, .cyan]
        ) {
            print("Blue tapped")
        }

        GradientButton(
            title: "Sunset Gradient",
            colors: [.orange, .pink, .purple]
        ) {
            print("Sunset tapped")
        }

        GradientButton(
            title: "Green Gradient",
            colors: [.green, .mint]
        ) {
            print("Green tapped")
        }

        GradientButton(
            title: "Fire Gradient",
            colors: [.red, .orange, .yellow]
        ) {
            print("Fire tapped")
        }

        GradientButton(
            title: "Ocean Gradient",
            colors: [.blue, .cyan, .mint]
        ) {
            print("Ocean tapped")
        }

        GradientButton(
            title: "Custom Gradient",
            gradient: LinearGradient(
                colors: [.purple, .blue, .cyan],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        ) {
            print("Custom tapped")
        }
    }
    .padding()
}
