import SwiftUI

public struct TimelineView: View {
    let items: [TimelineItem]
    let lineColor: Color
    let dotColor: Color

    public init(
        items: [TimelineItem],
        lineColor: Color = .blue,
        dotColor: Color = .blue
    ) {
        self.items = items
        self.lineColor = lineColor
        self.dotColor = dotColor
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(0..<items.count, id: \.self) { index in
                HStack(alignment: .top, spacing: 12) {
                    VStack(spacing: 0) {
                        Circle()
                            .fill(items[index].isCompleted ? dotColor : Color(.systemGray4))
                            .frame(width: 12, height: 12)
                            .overlay(
                                Circle()
                                    .strokeBorder(Color(.systemBackground), lineWidth: 2)
                            )

                        if index < items.count - 1 {
                            Rectangle()
                                .fill(items[index].isCompleted ? lineColor : Color(.systemGray4))
                                .frame(width: 2)
                                .frame(minHeight: 40)
                        }
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(items[index].title)
                            .font(.subheadline)
                            .fontWeight(.semibold)

                        if let description = items[index].description {
                            Text(description)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }

                        if let timestamp = items[index].timestamp {
                            Text(timestamp)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.bottom, index < items.count - 1 ? 20 : 0)

                    Spacer()
                }
            }
        }
    }
}

public struct TimelineItem {
    let title: String
    let description: String?
    let timestamp: String?
    let isCompleted: Bool

    public init(
        title: String,
        description: String? = nil,
        timestamp: String? = nil,
        isCompleted: Bool = true
    ) {
        self.title = title
        self.description = description
        self.timestamp = timestamp
        self.isCompleted = isCompleted
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 40) {
            VStack(alignment: .leading, spacing: 16) {
                Text("Order Timeline")
                    .font(.title2)
                    .fontWeight(.bold)

                TimelineView(
                    items: [
                        TimelineItem(
                            title: "Order Placed",
                            description: "Your order has been received",
                            timestamp: "Dec 15, 10:30 AM",
                            isCompleted: true
                        ),
                        TimelineItem(
                            title: "Processing",
                            description: "We're preparing your order",
                            timestamp: "Dec 15, 11:00 AM",
                            isCompleted: true
                        ),
                        TimelineItem(
                            title: "Shipped",
                            description: "Your order is on the way",
                            timestamp: "Dec 16, 9:00 AM",
                            isCompleted: true
                        ),
                        TimelineItem(
                            title: "Out for Delivery",
                            description: "Expected delivery today",
                            isCompleted: false
                        ),
                        TimelineItem(
                            title: "Delivered",
                            isCompleted: false
                        )
                    ],
                    lineColor: .green,
                    dotColor: .green
                )
            }

            VStack(alignment: .leading, spacing: 16) {
                Text("Project Progress")
                    .font(.title2)
                    .fontWeight(.bold)

                TimelineView(
                    items: [
                        TimelineItem(
                            title: "Project Kickoff",
                            description: "Initial meeting with stakeholders",
                            timestamp: "Jan 1",
                            isCompleted: true
                        ),
                        TimelineItem(
                            title: "Requirements Gathering",
                            description: "Collected all project requirements",
                            timestamp: "Jan 5",
                            isCompleted: true
                        ),
                        TimelineItem(
                            title: "Design Phase",
                            description: "UI/UX design in progress",
                            timestamp: "Jan 10",
                            isCompleted: true
                        ),
                        TimelineItem(
                            title: "Development",
                            description: "Currently in development",
                            isCompleted: false
                        )
                    ],
                    lineColor: .purple,
                    dotColor: .purple
                )
            }
        }
        .padding()
    }
}
