import SwiftUI

public struct ChipView: View {
    let text: String
    let systemImage: String?
    let isSelected: Bool
    let color: Color
    let onTap: (() -> Void)?

    public init(
        _ text: String,
        systemImage: String? = nil,
        isSelected: Bool = false,
        color: Color = .blue,
        onTap: (() -> Void)? = nil
    ) {
        self.text = text
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.color = color
        self.onTap = onTap
    }

    public var body: some View {
        Button(action: { onTap?() }) {
            HStack(spacing: 6) {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.caption)
                }
                Text(text)
                    .font(.subheadline)
                    .fontWeight(.medium)
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(isSelected ? color : color.opacity(0.15))
            .foregroundColor(isSelected ? .white : color)
            .cornerRadius(20)
        }
        .buttonStyle(LabelButtonStyle())
    }
}

public struct ChipGroup: View {
    let chips: [String]
    @Binding var selectedChips: Set<String>
    let color: Color
    let multipleSelection: Bool

    public init(
        chips: [String],
        selectedChips: Binding<Set<String>>,
        color: Color = .blue,
        multipleSelection: Bool = true
    ) {
        self.chips = chips
        self._selectedChips = selectedChips
        self.color = color
        self.multipleSelection = multipleSelection
    }

    public var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(chips, id: \.self) { chip in
                ChipView(
                    chip,
                    isSelected: selectedChips.contains(chip),
                    color: color
                ) {
                    toggleChip(chip)
                }
            }
        }
    }

    private func toggleChip(_ chip: String) {
        if multipleSelection {
            if selectedChips.contains(chip) {
                selectedChips.remove(chip)
            } else {
                selectedChips.insert(chip)
            }
        } else {
            if selectedChips.contains(chip) {
                selectedChips.removeAll()
            } else {
                selectedChips = [chip]
            }
        }
    }
}

// FlowLayout for wrapping chips
public struct FlowLayout: Layout {
    var spacing: CGFloat

    public init(spacing: CGFloat = 8) {
        self.spacing = spacing
    }

    public func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = FlowResult(
            in: proposal.replacingUnspecifiedDimensions().width,
            subviews: subviews,
            spacing: spacing
        )
        return result.size
    }

    public func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = FlowResult(
            in: bounds.width,
            subviews: subviews,
            spacing: spacing
        )
        for (index, subview) in subviews.enumerated() {
            subview.place(at: result.positions[index], proposal: .unspecified)
        }
    }

    struct FlowResult {
        var size: CGSize = .zero
        var positions: [CGPoint] = []

        init(in maxWidth: CGFloat, subviews: Subviews, spacing: CGFloat) {
            var x: CGFloat = 0
            var y: CGFloat = 0
            var lineHeight: CGFloat = 0

            for subview in subviews {
                let size = subview.sizeThatFits(.unspecified)

                if x + size.width > maxWidth && x > 0 {
                    x = 0
                    y += lineHeight + spacing
                    lineHeight = 0
                }

                positions.append(CGPoint(x: x, y: y))
                lineHeight = max(lineHeight, size.height)
                x += size.width + spacing
            }

            self.size = CGSize(width: maxWidth, height: y + lineHeight)
        }
    }
}

#Preview {
    struct ChipPreview: View {
        @State private var selectedChips: Set<String> = ["Swift"]
        @State private var singleSelection: Set<String> = ["Medium"]

        var body: some View {
            ScrollView {
                VStack(spacing: 30) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Individual Chips")
                            .font(.headline)

                        HStack {
                            ChipView("Swift", systemImage: "swift", isSelected: true)
                            ChipView("SwiftUI", isSelected: false)
                            ChipView("iOS", systemImage: "apple.logo", isSelected: true, color: .purple)
                        }
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Multiple Selection")
                            .font(.headline)

                        ChipGroup(
                            chips: ["Swift", "SwiftUI", "UIKit", "Combine", "CoreData", "Xcode"],
                            selectedChips: $selectedChips,
                            color: .blue,
                            multipleSelection: true
                        )
                    }

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Single Selection")
                            .font(.headline)

                        ChipGroup(
                            chips: ["Small", "Medium", "Large", "XLarge"],
                            selectedChips: $singleSelection,
                            color: .green,
                            multipleSelection: false
                        )
                    }
                }
                .padding()
            }
        }
    }

    return ChipPreview()
}
