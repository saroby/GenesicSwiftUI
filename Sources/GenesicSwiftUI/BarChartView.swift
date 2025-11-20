import SwiftUI

public struct BarChartView: View {
    let data: [BarChartData]
    let maxValue: Double?
    let showValues: Bool
    let barColor: Color

    public init(
        data: [BarChartData],
        maxValue: Double? = nil,
        showValues: Bool = true,
        barColor: Color = .blue
    ) {
        self.data = data
        self.maxValue = maxValue
        self.showValues = showValues
        self.barColor = barColor
    }

    private var calculatedMaxValue: Double {
        maxValue ?? data.map { $0.value }.max() ?? 1
    }

    public var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .bottom, spacing: 12) {
                ForEach(data) { item in
                    VStack(spacing: 8) {
                        if showValues {
                            Text(item.formattedValue)
                                .font(.caption2)
                                .fontWeight(.semibold)
                                .foregroundColor(item.color ?? barColor)
                        }

                        RoundedRectangle(cornerRadius: 4)
                            .fill(item.color ?? barColor)
                            .frame(
                                width: nil,
                                height: CGFloat(item.value / calculatedMaxValue) * 150
                            )
                            .frame(minHeight: 4)

                        Text(item.label)
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .frame(height: 200)
        }
    }
}

public struct BarChartData: Identifiable {
    public let id = UUID()
    let label: String
    let value: Double
    let color: Color?
    let formattedValue: String

    public init(
        label: String,
        value: Double,
        color: Color? = nil,
        formatValue: ((Double) -> String)? = nil
    ) {
        self.label = label
        self.value = value
        self.color = color
        self.formattedValue = formatValue?(value) ?? String(format: "%.0f", value)
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Monthly Sales")
                    .font(.title2)
                    .fontWeight(.bold)

                BarChartView(
                    data: [
                        BarChartData(label: "Jan", value: 120),
                        BarChartData(label: "Feb", value: 150),
                        BarChartData(label: "Mar", value: 90),
                        BarChartData(label: "Apr", value: 180),
                        BarChartData(label: "May", value: 200),
                        BarChartData(label: "Jun", value: 170)
                    ]
                )
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Revenue by Category")
                    .font(.title2)
                    .fontWeight(.bold)

                BarChartView(
                    data: [
                        BarChartData(label: "Food", value: 45000, color: .green) { "$\(Int($0))" },
                        BarChartData(label: "Tech", value: 72000, color: .blue) { "$\(Int($0))" },
                        BarChartData(label: "Fashion", value: 38000, color: .purple) { "$\(Int($0))" },
                        BarChartData(label: "Sports", value: 54000, color: .orange) { "$\(Int($0))" }
                    ],
                    showValues: true,
                    barColor: .blue
                )
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Weekly Activity")
                    .font(.title2)
                    .fontWeight(.bold)

                BarChartView(
                    data: [
                        BarChartData(label: "Mon", value: 5.5, color: .cyan) { "\($0, default: "%.1f")h" },
                        BarChartData(label: "Tue", value: 7.2, color: .cyan) { "\($0, default: "%.1f")h" },
                        BarChartData(label: "Wed", value: 6.8, color: .cyan) { "\($0, default: "%.1f")h" },
                        BarChartData(label: "Thu", value: 8.0, color: .cyan) { "\($0, default: "%.1f")h" },
                        BarChartData(label: "Fri", value: 6.5, color: .cyan) { "\($0, default: "%.1f")h" },
                        BarChartData(label: "Sat", value: 3.2, color: .cyan) { "\($0, default: "%.1f")h" },
                        BarChartData(label: "Sun", value: 2.8, color: .cyan) { "\($0, default: "%.1f")h" }
                    ],
                    barColor: .cyan
                )
            }
        }
        .padding()
    }
}
