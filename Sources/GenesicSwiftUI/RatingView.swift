import SwiftUI

public struct RatingView: View {
    @Binding var rating: Int
    let maxRating: Int
    let size: CGFloat
    let color: Color
    let fillColor: Color
    let isEditable: Bool

    public init(
        rating: Binding<Int>,
        maxRating: Int = 5,
        size: CGFloat = 24,
        color: Color = .yellow,
        fillColor: Color = .gray,
        isEditable: Bool = true
    ) {
        self._rating = rating
        self.maxRating = maxRating
        self.size = size
        self.color = color
        self.fillColor = fillColor
        self.isEditable = isEditable
    }

    public var body: some View {
        HStack(spacing: 4) {
            ForEach(1...maxRating, id: \.self) { index in
                Image(systemName: index <= rating ? "star.fill" : "star")
                    .font(.system(size: size))
                    .foregroundColor(index <= rating ? color : fillColor)
                    .onTapGesture {
                        if isEditable {
                            rating = index
                        }
                    }
            }
        }
    }
}

public struct StaticRatingView: View {
    let rating: Double
    let maxRating: Int
    let size: CGFloat
    let color: Color
    let fillColor: Color
    let showValue: Bool

    public init(
        rating: Double,
        maxRating: Int = 5,
        size: CGFloat = 16,
        color: Color = .yellow,
        fillColor: Color = .gray,
        showValue: Bool = false
    ) {
        self.rating = min(max(rating, 0), Double(maxRating))
        self.maxRating = maxRating
        self.size = size
        self.color = color
        self.fillColor = fillColor
        self.showValue = showValue
    }

    public var body: some View {
        HStack(spacing: 4) {
            HStack(spacing: 2) {
                ForEach(0..<maxRating, id: \.self) { index in
                    starView(for: index)
                }
            }

            if showValue {
                Text(String(format: "%.1f", rating))
                    .font(.system(size: size * 0.8))
                    .foregroundColor(.secondary)
            }
        }
    }

    @ViewBuilder
    private func starView(for index: Int) -> some View {
        let fillAmount = min(max(rating - Double(index), 0), 1)

        ZStack {
            Image(systemName: "star.fill")
                .font(.system(size: size))
                .foregroundColor(fillColor)

            if fillAmount > 0 {
                GeometryReader { geometry in
                    Image(systemName: "star.fill")
                        .font(.system(size: size))
                        .foregroundColor(color)
                        .mask(
                            Rectangle()
                                .frame(width: geometry.size.width * fillAmount)
                        )
                }
            }
        }
        .frame(width: size, height: size)
    }
}

#Preview {
    struct RatingPreview: View {
        @State private var rating1 = 3
        @State private var rating2 = 4
        @State private var rating3 = 5

        var body: some View {
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Editable Rating")
                        .font(.headline)

                    RatingView(rating: $rating1)
                    RatingView(rating: $rating2, size: 32, color: .orange)
                    RatingView(rating: $rating3, size: 40, color: .red)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Read-only Rating")
                        .font(.headline)

                    RatingView(rating: .constant(3), isEditable: false)
                    RatingView(rating: .constant(4), size: 20, color: .blue, isEditable: false)
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Static Rating with Decimals")
                        .font(.headline)

                    StaticRatingView(rating: 3.5, showValue: true)
                    StaticRatingView(rating: 4.2, size: 20, color: .orange, showValue: true)
                    StaticRatingView(rating: 2.8, size: 24, color: .purple, showValue: true)
                }
            }
            .padding()
        }
    }

    return RatingPreview()
}
