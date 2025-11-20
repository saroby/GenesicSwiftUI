import SwiftUI

public struct AvatarView: View {
    public enum AvatarSize {
        case small, medium, large, xLarge

        var value: CGFloat {
            switch self {
            case .small: return 32
            case .medium: return 48
            case .large: return 64
            case .xLarge: return 96
            }
        }

        var fontSize: CGFloat {
            switch self {
            case .small: return 14
            case .medium: return 18
            case .large: return 24
            case .xLarge: return 36
            }
        }
    }

    let imageURL: URL?
    let initials: String?
    let size: AvatarSize
    let backgroundColor: Color
    let showBorder: Bool
    let borderColor: Color

    public init(
        imageURL: URL? = nil,
        initials: String? = nil,
        size: AvatarSize = .medium,
        backgroundColor: Color = .blue,
        showBorder: Bool = false,
        borderColor: Color = .white
    ) {
        self.imageURL = imageURL
        self.initials = initials
        self.size = size
        self.backgroundColor = backgroundColor
        self.showBorder = showBorder
        self.borderColor = borderColor
    }

    public var body: some View {
        Group {
            if let imageURL = imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .scaledToFill()
                } placeholder: {
                    placeholderView
                }
            } else {
                placeholderView
            }
        }
        .frame(width: size.value, height: size.value)
        .clipShape(Circle())
        .overlay(
            Circle()
                .strokeBorder(borderColor, lineWidth: showBorder ? 2 : 0)
        )
    }

    private var placeholderView: some View {
        ZStack {
            Circle()
                .fill(backgroundColor)

            if let initials = initials {
                Text(initials)
                    .font(.system(size: size.fontSize, weight: .semibold))
                    .foregroundColor(.white)
            } else {
                Image(systemName: "person.fill")
                    .font(.system(size: size.fontSize))
                    .foregroundColor(.white)
            }
        }
    }
}

public struct AvatarGroupView: View {
    let avatars: [AvatarData]
    let size: AvatarView.AvatarSize
    let maxVisible: Int
    let spacing: CGFloat

    public init(
        avatars: [AvatarData],
        size: AvatarView.AvatarSize = .medium,
        maxVisible: Int = 4,
        spacing: CGFloat = -12
    ) {
        self.avatars = avatars
        self.size = size
        self.maxVisible = maxVisible
        self.spacing = spacing
    }

    public var body: some View {
        HStack(spacing: spacing) {
            ForEach(0..<min(avatars.count, maxVisible), id: \.self) { index in
                AvatarView(
                    imageURL: avatars[index].imageURL,
                    initials: avatars[index].initials,
                    size: size,
                    backgroundColor: avatars[index].color,
                    showBorder: true
                )
                .zIndex(Double(maxVisible - index))
            }

            if avatars.count > maxVisible {
                ZStack {
                    Circle()
                        .fill(Color(.systemGray5))

                    Text("+\(avatars.count - maxVisible)")
                        .font(.system(size: size.fontSize, weight: .semibold))
                        .foregroundColor(.secondary)
                }
                .frame(width: size.value, height: size.value)
            }
        }
    }
}

public struct AvatarData {
    let imageURL: URL?
    let initials: String?
    let color: Color

    public init(imageURL: URL? = nil, initials: String? = nil, color: Color = .blue) {
        self.imageURL = imageURL
        self.initials = initials
        self.color = color
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Avatar Sizes")
                    .font(.headline)

                HStack(spacing: 16) {
                    AvatarView(initials: "AB", size: .small)
                    AvatarView(initials: "CD", size: .medium, backgroundColor: .green)
                    AvatarView(initials: "EF", size: .large, backgroundColor: .purple)
                    AvatarView(initials: "GH", size: .xLarge, backgroundColor: .orange)
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("With Images")
                    .font(.headline)

                HStack(spacing: 16) {
                    AvatarView(
                        imageURL: URL(string: "https://picsum.photos/100"),
                        size: .medium,
                        showBorder: true
                    )
                    AvatarView(
                        imageURL: URL(string: "https://picsum.photos/101"),
                        size: .large,
                        showBorder: true,
                        borderColor: .blue
                    )
                }
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Avatar Group")
                    .font(.headline)

                AvatarGroupView(
                    avatars: [
                        AvatarData(initials: "JD", color: .blue),
                        AvatarData(initials: "SM", color: .green),
                        AvatarData(initials: "AK", color: .purple),
                        AvatarData(initials: "MJ", color: .orange),
                        AvatarData(initials: "LT", color: .red),
                        AvatarData(initials: "KP", color: .pink)
                    ],
                    size: .medium,
                    maxVisible: 4
                )
            }
        }
        .padding()
    }
}
