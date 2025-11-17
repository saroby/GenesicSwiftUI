import SwiftUI

public struct ColorPickerView: View {
    @Binding var selectedColor: Color
    let colors: [Color]
    let columns: Int

    public init(
        selectedColor: Binding<Color>,
        colors: [Color] = [
            .red, .orange, .yellow, .green, .blue, .purple,
            .pink, .gray, .brown, .cyan, .indigo, .mint
        ],
        columns: Int = 6
    ) {
        self._selectedColor = selectedColor
        self.colors = colors
        self.columns = columns
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.flexible()), count: columns)
    }

    public var body: some View {
        LazyVGrid(columns: gridColumns, spacing: 12) {
            ForEach(colors.indices, id: \.self) { index in
                Button(action: {
                    selectedColor = colors[index]
                }) {
                    Circle()
                        .fill(colors[index])
                        .frame(width: 44, height: 44)
                        .overlay(
                            Circle()
                                .strokeBorder(Color.white, lineWidth: 3)
                                .opacity(isSelected(colors[index]) ? 1 : 0)
                        )
                        .overlay(
                            Circle()
                                .strokeBorder(Color.blue, lineWidth: 2)
                                .opacity(isSelected(colors[index]) ? 1 : 0)
                        )
                }
                .buttonStyle(LabelButtonStyle())
            }
        }
    }

    private func isSelected(_ color: Color) -> Bool {
        // Simple comparison - in production you might want a more robust comparison
        color.description == selectedColor.description
    }
}

#Preview {
    struct ColorPickerPreview: View {
        @State private var selectedColor: Color = .blue

        var body: some View {
            VStack(spacing: 32) {
                Text("Select a Color")
                    .font(.title2)
                    .fontWeight(.bold)

                ColorPickerView(selectedColor: $selectedColor)

                RoundedRectangle(cornerRadius: 12)
                    .fill(selectedColor)
                    .frame(height: 100)
                    .overlay(
                        Text("Selected Color")
                            .font(.headline)
                            .foregroundColor(.white)
                    )

                Text("Selected: \(selectedColor.description)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }

    return ColorPickerPreview()
}
