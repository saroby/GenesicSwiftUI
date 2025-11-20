import SwiftUI
import CoreImage.CIFilterBuiltins

public struct QRCodeView: View {
    let text: String
    let size: CGFloat
    let foregroundColor: Color
    let backgroundColor: Color

    public init(
        text: String,
        size: CGFloat = 200,
        foregroundColor: Color = .black,
        backgroundColor: Color = .white
    ) {
        self.text = text
        self.size = size
        self.foregroundColor = foregroundColor
        self.backgroundColor = backgroundColor
    }

    public var body: some View {
        if let qrImage = generateQRCode(from: text) {
            Image(uiImage: qrImage)
                .interpolation(.none)
                .resizable()
                .frame(width: size, height: size)
        } else {
            Rectangle()
                .fill(Color(.systemGray5))
                .frame(width: size, height: size)
                .overlay(
                    Text("Unable to generate QR Code")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                )
        }
    }

    private func generateQRCode(from string: String) -> UIImage? {
        let context = CIContext()
        let filter = CIFilter.qrCodeGenerator()

        filter.message = Data(string.utf8)
        filter.correctionLevel = "M"

        guard let outputImage = filter.outputImage else { return nil }

        // Apply color filter
        let colorFilter = CIFilter.falseColor()
        colorFilter.inputImage = outputImage
        colorFilter.color0 = CIColor(color: UIColor(foregroundColor))
        colorFilter.color1 = CIColor(color: UIColor(backgroundColor))

        guard let coloredImage = colorFilter.outputImage,
              let cgImage = context.createCGImage(coloredImage, from: coloredImage.extent) else {
            return nil
        }

        return UIImage(cgImage: cgImage)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 32) {
            VStack(spacing: 16) {
                Text("Website URL")
                    .font(.headline)

                QRCodeView(text: "https://www.example.com")
            }

            VStack(spacing: 16) {
                Text("Email Address")
                    .font(.headline)

                QRCodeView(
                    text: "mailto:contact@example.com",
                    size: 150
                )
            }

            VStack(spacing: 16) {
                Text("Phone Number")
                    .font(.headline)

                QRCodeView(
                    text: "tel:+1234567890",
                    size: 150,
                    foregroundColor: .blue
                )
            }

            VStack(spacing: 16) {
                Text("WiFi Credentials")
                    .font(.headline)

                QRCodeView(
                    text: "WIFI:T:WPA;S:MyNetwork;P:MyPassword;;",
                    size: 200,
                    foregroundColor: .purple
                )
            }

            VStack(spacing: 16) {
                Text("Custom Text")
                    .font(.headline)

                QRCodeView(
                    text: "Hello, SwiftUI!",
                    size: 120,
                    foregroundColor: .green
                )
            }
        }
        .padding()
    }
}
