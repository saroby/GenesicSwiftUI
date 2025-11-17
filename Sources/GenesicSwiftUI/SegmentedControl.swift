import SwiftUI

public struct SegmentedControl: View {
    @Binding var selectedIndex: Int
    let segments: [String]
    let color: Color

    public init(
        selectedIndex: Binding<Int>,
        segments: [String],
        color: Color = .blue
    ) {
        self._selectedIndex = selectedIndex
        self.segments = segments
        self.color = color
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<segments.count, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedIndex = index
                    }
                }) {
                    Text(segments[index])
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(selectedIndex == index ? .white : color)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity)
                        .background(
                            selectedIndex == index ? color : Color.clear
                        )
                }
                .buttonStyle(LabelButtonStyle())
            }
        }
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

#Preview {
    struct SegmentedControlPreview: View {
        @State private var selectedIndex1 = 0
        @State private var selectedIndex2 = 1

        var body: some View {
            VStack(spacing: 30) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Two Segments")
                        .font(.headline)

                    SegmentedControl(
                        selectedIndex: $selectedIndex1,
                        segments: ["List", "Grid"]
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Three Segments")
                        .font(.headline)

                    SegmentedControl(
                        selectedIndex: $selectedIndex2,
                        segments: ["Day", "Week", "Month"],
                        color: .green
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Four Segments")
                        .font(.headline)

                    SegmentedControl(
                        selectedIndex: .constant(2),
                        segments: ["All", "Active", "Completed", "Archived"],
                        color: .purple
                    )
                }
            }
            .padding()
        }
    }

    return SegmentedControlPreview()
}
