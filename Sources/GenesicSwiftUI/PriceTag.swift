import SwiftUI

public struct PriceTag: View {
    let price: String
    let originalPrice: String?
    let currency: String
    let size: PriceSize
    let showDiscount: Bool

    public init(
        price: String,
        originalPrice: String? = nil,
        currency: String = "$",
        size: PriceSize = .medium,
        showDiscount: Bool = true
    ) {
        self.price = price
        self.originalPrice = originalPrice
        self.currency = currency
        self.size = size
        self.showDiscount = showDiscount
    }

    private var discount: String? {
        guard showDiscount,
              let original = originalPrice,
              let originalValue = Double(original),
              let currentValue = Double(price) else {
            return nil
        }

        let discountPercent = ((originalValue - currentValue) / originalValue) * 100
        return String(format: "%.0f%% OFF", discountPercent)
    }

    public var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 4) {
            Text(currency)
                .font(size.currencyFont)
                .fontWeight(.semibold)

            Text(price)
                .font(size.priceFont)
                .fontWeight(.bold)

            if let originalPrice = originalPrice {
                Text(currency + originalPrice)
                    .font(size.originalPriceFont)
                    .foregroundColor(.secondary)
                    .strikethrough()
            }

            if let discount = discount {
                Text(discount)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.vertical, 2)
                    .background(Color.red)
                    .cornerRadius(4)
            }
        }
    }

    public enum PriceSize {
        case small, medium, large

        var priceFont: Font {
            switch self {
            case .small: return .title3
            case .medium: return .title2
            case .large: return .largeTitle
            }
        }

        var currencyFont: Font {
            switch self {
            case .small: return .body
            case .medium: return .title3
            case .large: return .title
            }
        }

        var originalPriceFont: Font {
            switch self {
            case .small: return .caption
            case .medium: return .subheadline
            case .large: return .body
            }
        }
    }
}

#Preview {
    VStack(spacing: 32) {
        VStack(alignment: .leading, spacing: 16) {
            Text("Price Sizes")
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                PriceTag(price: "29.99", size: .small)
                PriceTag(price: "49.99", size: .medium)
                PriceTag(price: "99.99", size: .large)
            }
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("With Original Price")
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                PriceTag(price: "19.99", originalPrice: "29.99", size: .small)
                PriceTag(price: "39.99", originalPrice: "59.99", size: .medium)
                PriceTag(price: "79.99", originalPrice: "129.99", size: .large)
            }
        }

        VStack(alignment: .leading, spacing: 16) {
            Text("Different Currencies")
                .font(.headline)

            VStack(alignment: .leading, spacing: 12) {
                PriceTag(price: "99.99", originalPrice: "149.99", currency: "$")
                PriceTag(price: "89.99", originalPrice: "119.99", currency: "€")
                PriceTag(price: "79.99", originalPrice: "99.99", currency: "£")
            }
        }
    }
    .padding()
}
