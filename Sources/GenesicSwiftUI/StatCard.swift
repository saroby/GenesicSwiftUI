import SwiftUI

public struct StatCard: View {
    let title: String
    let value: String
    let icon: String?
    let trend: Trend?
    let color: Color

    public init(
        title: String,
        value: String,
        icon: String? = nil,
        trend: Trend? = nil,
        color: Color = .blue
    ) {
        self.title = title
        self.value = value
        self.icon = icon
        self.trend = trend
        self.color = color
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(value)
                        .font(.title)
                        .fontWeight(.bold)
                }

                Spacer()

                if let icon = icon {
                    Image(systemName: icon)
                        .font(.title2)
                        .foregroundColor(color)
                        .padding(12)
                        .background(color.opacity(0.15))
                        .clipShape(Circle())
                }
            }

            if let trend = trend {
                HStack(spacing: 4) {
                    Image(systemName: trend.isPositive ? "arrow.up.right" : "arrow.down.right")
                        .font(.caption)

                    Text(trend.text)
                        .font(.caption)
                }
                .foregroundColor(trend.isPositive ? .green : .red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }

    public struct Trend {
        let text: String
        let isPositive: Bool

        public init(text: String, isPositive: Bool) {
            self.text = text
            self.isPositive = isPositive
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 16) {
                StatCard(
                    title: "Total Sales",
                    value: "$24.5K",
                    icon: "dollarsign.circle.fill",
                    trend: StatCard.Trend(text: "+12.5% from last month", isPositive: true),
                    color: .green
                )

                StatCard(
                    title: "New Users",
                    value: "1,234",
                    icon: "person.3.fill",
                    trend: StatCard.Trend(text: "+8.2% from last week", isPositive: true),
                    color: .blue
                )

                StatCard(
                    title: "Orders",
                    value: "892",
                    icon: "cart.fill",
                    trend: StatCard.Trend(text: "-3.1% from last month", isPositive: false),
                    color: .orange
                )

                StatCard(
                    title: "Revenue",
                    value: "$48.2K",
                    icon: "chart.line.uptrend.xyaxis",
                    trend: StatCard.Trend(text: "+15.3% from last month", isPositive: true),
                    color: .purple
                )
            }

            VStack(spacing: 16) {
                StatCard(
                    title: "Total Views",
                    value: "125.4K",
                    icon: "eye.fill",
                    color: .indigo
                )

                StatCard(
                    title: "Downloads",
                    value: "3,421",
                    icon: "arrow.down.circle.fill",
                    color: .teal
                )
            }
        }
        .padding()
    }
}
