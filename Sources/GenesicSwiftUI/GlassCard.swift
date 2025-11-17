import SwiftUI

public struct GlassCard<Content: View>: View {
    let content: Content
    let cornerRadius: CGFloat
    let opacity: Double

    public init(
        cornerRadius: CGFloat = 16,
        opacity: Double = 0.2,
        @ViewBuilder content: () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.opacity = opacity
        self.content = content()
    }

    public var body: some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(.ultraThinMaterial)
                    .opacity(opacity)
            )
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [.purple, .blue, .cyan],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()

        ScrollView {
            VStack(spacing: 24) {
                GlassCard {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Glass Effect Card")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("This card uses a glass morphism effect with blur and transparency.")
                            .font(.body)
                            .foregroundColor(.secondary)

                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("Featured")
                        }
                    }
                }

                GlassCard(cornerRadius: 24, opacity: 0.3) {
                    VStack(spacing: 16) {
                        Image(systemName: "heart.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.pink)

                        Text("Likes")
                            .font(.title3)
                            .fontWeight(.semibold)

                        Text("1,234")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                    }
                }

                GlassCard {
                    HStack(spacing: 16) {
                        Image(systemName: "bell.fill")
                            .font(.title)
                            .foregroundColor(.orange)

                        VStack(alignment: .leading) {
                            Text("Notifications")
                                .font(.headline)
                            Text("You have 3 new notifications")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        Spacer()
                    }
                }
            }
            .padding()
        }
    }
}
