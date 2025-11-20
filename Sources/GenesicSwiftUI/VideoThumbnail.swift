import SwiftUI
import AVFoundation

public struct VideoThumbnail: View {
    let videoURL: URL
    let size: CGSize
    let cornerRadius: CGFloat
    @State private var thumbnail: UIImage?

    public init(
        videoURL: URL,
        size: CGSize = CGSize(width: 200, height: 150),
        cornerRadius: CGFloat = 12
    ) {
        self.videoURL = videoURL
        self.size = size
        self.cornerRadius = cornerRadius
    }

    public var body: some View {
        ZStack {
            if let thumbnail = thumbnail {
                Image(uiImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.width, height: size.height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            } else {
                Rectangle()
                    .fill(Color(.systemGray5))
                    .frame(width: size.width, height: size.height)
                    .cornerRadius(cornerRadius)
                    .overlay(
                        ProgressView()
                    )
            }

            Image(systemName: "play.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.3), radius: 5)
        }
        .onAppear {
            generateThumbnail()
        }
    }

    private func generateThumbnail() {
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true

        let time = CMTime(seconds: 1, preferredTimescale: 60)

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let cgImage = try imageGenerator.copyCGImage(at: time, actualTime: nil)
                let image = UIImage(cgImage: cgImage)

                DispatchQueue.main.async {
                    self.thumbnail = image
                }
            } catch {
                print("Failed to generate thumbnail: \(error)")
            }
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        Text("Video Thumbnails")
            .font(.title)
            .fontWeight(.bold)

        Text("Note: This preview shows placeholder UI.\nActual video thumbnails require valid video URLs.")
            .font(.caption)
            .foregroundColor(.secondary)
            .multilineTextAlignment(.center)

        // Placeholder demonstration
        ZStack {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: 200, height: 150)
                .cornerRadius(12)

            Image(systemName: "play.circle.fill")
                .font(.system(size: 50))
                .foregroundColor(.white)
        }
    }
    .padding()
}
