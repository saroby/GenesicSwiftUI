import SwiftUI

public struct ProfileHeader: View {
    let imageURL: URL?
    let name: String
    let subtitle: String?
    let isVerified: Bool
    let stats: [ProfileStat]
    let onEdit: (() -> Void)?

    public init(
        imageURL: URL? = nil,
        name: String,
        subtitle: String? = nil,
        isVerified: Bool = false,
        stats: [ProfileStat] = [],
        onEdit: (() -> Void)? = nil
    ) {
        self.imageURL = imageURL
        self.name = name
        self.subtitle = subtitle
        self.isVerified = isVerified
        self.stats = stats
        self.onEdit = onEdit
    }

    public var body: some View {
        VStack(spacing: 16) {
            HStack(spacing: 16) {
                AvatarView(
                    imageURL: imageURL,
                    initials: String(name.prefix(2)).uppercased(),
                    size: .xLarge,
                    showBorder: true
                )

                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text(name)
                            .font(.title2)
                            .fontWeight(.bold)

                        if isVerified {
                            Image(systemName: "checkmark.seal.fill")
                                .foregroundColor(.blue)
                        }
                    }

                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }

                    if let onEdit = onEdit {
                        Button("Edit Profile") {
                            onEdit()
                        }
                        .font(.caption)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                        .buttonStyle(LabelButtonStyle())
                    }
                }

                Spacer()
            }

            if !stats.isEmpty {
                HStack(spacing: 0) {
                    ForEach(stats.indices, id: \.self) { index in
                        VStack(spacing: 4) {
                            Text(stats[index].value)
                                .font(.title3)
                                .fontWeight(.bold)

                            Text(stats[index].label)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity)

                        if index < stats.count - 1 {
                            Divider()
                                .frame(height: 30)
                        }
                    }
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(12)
            }
        }
    }

    public struct ProfileStat {
        let label: String
        let value: String

        public init(label: String, value: String) {
            self.label = label
            self.value = value
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            ProfileHeader(
                imageURL: URL(string: "https://picsum.photos/200"),
                name: "John Doe",
                subtitle: "iOS Developer",
                isVerified: true,
                stats: [
                    ProfileHeader.ProfileStat(label: "Posts", value: "124"),
                    ProfileHeader.ProfileStat(label: "Followers", value: "1.2K"),
                    ProfileHeader.ProfileStat(label: "Following", value: "456")
                ],
                onEdit: { print("Edit tapped") }
            )

            Divider()

            ProfileHeader(
                name: "Jane Smith",
                subtitle: "UX Designer at Apple",
                isVerified: false,
                stats: [
                    ProfileHeader.ProfileStat(label: "Projects", value: "45"),
                    ProfileHeader.ProfileStat(label: "Likes", value: "8.5K")
                ]
            )

            Divider()

            ProfileHeader(
                name: "Alex Johnson",
                isVerified: true,
                onEdit: { print("Edit tapped") }
            )
        }
        .padding()
    }
}
