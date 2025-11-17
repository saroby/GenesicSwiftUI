import SwiftUI

public struct TooltipView: View {
    let text: String
    let backgroundColor: Color
    let textColor: Color

    public init(
        text: String,
        backgroundColor: Color = Color(.darkGray),
        textColor: Color = .white
    ) {
        self.text = text
        self.backgroundColor = backgroundColor
        self.textColor = textColor
    }

    public var body: some View {
        Text(text)
            .font(.caption)
            .foregroundColor(textColor)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(backgroundColor)
            .cornerRadius(8)
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
    }
}

public struct TooltipModifier: ViewModifier {
    let text: String
    @Binding var isShowing: Bool
    let backgroundColor: Color
    let textColor: Color

    public func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    if isShowing {
                        TooltipView(
                            text: text,
                            backgroundColor: backgroundColor,
                            textColor: textColor
                        )
                        .position(
                            x: geometry.size.width / 2,
                            y: -20
                        )
                        .transition(.opacity.combined(with: .scale))
                    }
                }
            )
    }
}

public extension View {
    func tooltip(
        _ text: String,
        isShowing: Binding<Bool>,
        backgroundColor: Color = Color(.darkGray),
        textColor: Color = .white
    ) -> some View {
        modifier(TooltipModifier(
            text: text,
            isShowing: isShowing,
            backgroundColor: backgroundColor,
            textColor: textColor
        ))
    }
}

#Preview {
    struct TooltipPreview: View {
        @State private var showTooltip1 = false
        @State private var showTooltip2 = false
        @State private var showTooltip3 = false

        var body: some View {
            VStack(spacing: 60) {
                Text("Tooltips Demo")
                    .font(.title)
                    .fontWeight(.bold)

                VStack(spacing: 40) {
                    Button("Hover Me (Info)") {
                        withAnimation {
                            showTooltip1.toggle()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .tooltip("This is an info tooltip", isShowing: $showTooltip1)

                    Button("Hover Me (Success)") {
                        withAnimation {
                            showTooltip2.toggle()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle(color: .green))
                    .tooltip(
                        "Operation completed successfully!",
                        isShowing: $showTooltip2,
                        backgroundColor: .green
                    )

                    Button("Hover Me (Warning)") {
                        withAnimation {
                            showTooltip3.toggle()
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle(color: .orange))
                    .tooltip(
                        "Please be careful with this action",
                        isShowing: $showTooltip3,
                        backgroundColor: .orange
                    )
                }

                Spacer()

                Text("Static Tooltip Examples:")
                    .font(.headline)

                VStack(spacing: 16) {
                    TooltipView(text: "Default tooltip")
                    TooltipView(text: "Success!", backgroundColor: .green)
                    TooltipView(text: "Warning!", backgroundColor: .orange)
                    TooltipView(text: "Error!", backgroundColor: .red)
                }
            }
            .padding()
        }
    }

    return TooltipPreview()
}
