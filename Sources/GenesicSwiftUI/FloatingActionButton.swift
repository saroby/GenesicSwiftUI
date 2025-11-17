import SwiftUI

public struct FloatingActionButton: View {
    let icon: String
    let color: Color
    let size: FABSize
    let action: () -> Void

    public init(
        icon: String = "plus",
        color: Color = .blue,
        size: FABSize = .regular,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.color = color
        self.size = size
        self.action = action
    }

    public var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: size.iconSize, weight: .semibold))
                .foregroundColor(.white)
                .frame(width: size.dimension, height: size.dimension)
                .background(color)
                .clipShape(Circle())
                .shadow(color: color.opacity(0.4), radius: 10, x: 0, y: 5)
        }
        .buttonStyle(LabelButtonStyle())
    }

    public enum FABSize {
        case small, regular, large

        var dimension: CGFloat {
            switch self {
            case .small: return 48
            case .regular: return 56
            case .large: return 64
            }
        }

        var iconSize: CGFloat {
            switch self {
            case .small: return 20
            case .regular: return 24
            case .large: return 28
            }
        }
    }
}

public struct FABMenu: View {
    @Binding var isExpanded: Bool
    let items: [FABMenuItem]
    let mainIcon: String
    let color: Color

    public init(
        isExpanded: Binding<Bool>,
        items: [FABMenuItem],
        mainIcon: String = "plus",
        color: Color = .blue
    ) {
        self._isExpanded = isExpanded
        self.items = items
        self.mainIcon = mainIcon
        self.color = color
    }

    public var body: some View {
        VStack(spacing: 16) {
            if isExpanded {
                ForEach(items.reversed(), id: \.id) { item in
                    HStack {
                        Spacer()

                        Text(item.label)
                            .font(.subheadline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemBackground))
                            .cornerRadius(8)
                            .shadow(color: .black.opacity(0.1), radius: 5)

                        FloatingActionButton(
                            icon: item.icon,
                            color: item.color ?? color,
                            size: .small,
                            action: item.action
                        )
                    }
                    .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }

            FloatingActionButton(
                icon: isExpanded ? "xmark" : mainIcon,
                color: color,
                action: {
                    withAnimation(.spring()) {
                        isExpanded.toggle()
                    }
                }
            )
            .rotationEffect(.degrees(isExpanded ? 45 : 0))
        }
    }
}

public struct FABMenuItem: Identifiable {
    public let id = UUID()
    let icon: String
    let label: String
    let color: Color?
    let action: () -> Void

    public init(
        icon: String,
        label: String,
        color: Color? = nil,
        action: @escaping () -> Void
    ) {
        self.icon = icon
        self.label = label
        self.color = color
        self.action = action
    }
}

#Preview {
    struct FABPreview: View {
        @State private var isMenuExpanded = false

        var body: some View {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        ForEach(0..<20, id: \.self) { index in
                            Text("Item \(index + 1)")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        FABMenu(
                            isExpanded: $isMenuExpanded,
                            items: [
                                FABMenuItem(
                                    icon: "camera.fill",
                                    label: "Camera",
                                    color: .purple
                                ) {
                                    print("Camera")
                                },
                                FABMenuItem(
                                    icon: "photo.fill",
                                    label: "Photo",
                                    color: .orange
                                ) {
                                    print("Photo")
                                },
                                FABMenuItem(
                                    icon: "doc.fill",
                                    label: "Document",
                                    color: .green
                                ) {
                                    print("Document")
                                }
                            ]
                        )
                        .padding()
                    }
                }
            }
        }
    }

    return FABPreview()
}
