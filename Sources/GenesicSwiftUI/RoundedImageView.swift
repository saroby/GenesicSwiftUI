import SwiftUI

public struct RoundedImageView: View {
    let imageURL: URL?
    let placeholderImage: UIImage?
    let cornerRadius: CGFloat
    let aspectRatio: CGFloat?
    let contentMode: ContentMode

    public init(
        imageURL: URL?,
        placeholderImage: UIImage? = nil,
        cornerRadius: CGFloat = 12,
        aspectRatio: CGFloat? = nil,
        contentMode: ContentMode = .fill
    ) {
        self.imageURL = imageURL
        self.placeholderImage = placeholderImage
        self.cornerRadius = cornerRadius
        self.aspectRatio = aspectRatio
        self.contentMode = contentMode
    }

    public var body: some View {
        Group {
            if let imageURL = imageURL {
                AsyncImage(url: imageURL) { phase in
                    switch phase {
                    case .empty:
                        placeholderView
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: contentMode)
                    case .failure:
                        placeholderView
                    @unknown default:
                        placeholderView
                    }
                }
            } else {
                placeholderView
            }
        }
        .if(aspectRatio != nil) { view in
            view.aspectRatio(aspectRatio!, contentMode: .fit)
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }

    private var placeholderView: some View {
        Group {
            if let placeholderImage = placeholderImage {
                Image(uiImage: placeholderImage)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .overlay(
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundColor(.secondary)
                    )
            }
        }
    }
}

extension View {
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 24) {
            VStack(alignment: .leading, spacing: 12) {
                Text("With URL")
                    .font(.headline)

                RoundedImageView(
                    imageURL: URL(string: "https://picsum.photos/400/300"),
                    cornerRadius: 12
                )
                .frame(height: 200)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Square Aspect Ratio")
                    .font(.headline)

                RoundedImageView(
                    imageURL: URL(string: "https://picsum.photos/300"),
                    cornerRadius: 16,
                    aspectRatio: 1.0
                )
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("16:9 Aspect Ratio")
                    .font(.headline)

                RoundedImageView(
                    imageURL: URL(string: "https://picsum.photos/1600/900"),
                    cornerRadius: 8,
                    aspectRatio: 16/9
                )
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Placeholder (No URL)")
                    .font(.headline)

                RoundedImageView(
                    imageURL: nil,
                    cornerRadius: 12
                )
                .frame(height: 200)
            }
        }
        .padding()
    }
}
