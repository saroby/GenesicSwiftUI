import SwiftUI

public struct DividerView: View {
    let text: String?
    let color: Color
    let thickness: CGFloat

    public init(
        text: String? = nil,
        color: Color = Color(.separator),
        thickness: CGFloat = 1
    ) {
        self.text = text
        self.color = color
        self.thickness = thickness
    }

    public var body: some View {
        HStack(spacing: 16) {
            line

            if let text = text {
                Text(text)
                    .font(.caption)
                    .foregroundColor(.secondary)
                line
            }
        }
    }

    private var line: some View {
        Rectangle()
            .fill(color)
            .frame(height: thickness)
    }
}

#Preview {
    VStack(spacing: 32) {
        Text("Content Above")

        DividerView()

        Text("Content Below")

        DividerView(text: "OR")

        Text("More Content")

        DividerView(text: "Section Break", color: .blue, thickness: 2)

        Text("Final Content")
    }
    .padding()
}
