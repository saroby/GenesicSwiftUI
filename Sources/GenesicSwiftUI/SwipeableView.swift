import SwiftUI

public struct SwipeableView<Content: View, LeadingActions: View, TrailingActions: View>: View {
    let content: Content
    let leadingActions: LeadingActions?
    let trailingActions: TrailingActions?
    @State private var offset: CGFloat = 0
    @State private var isDragging = false

    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingActions: () -> LeadingActions,
        @ViewBuilder trailingActions: () -> TrailingActions
    ) {
        self.content = content()
        self.leadingActions = leadingActions()
        self.trailingActions = trailingActions()
    }

    public var body: some View {
        ZStack {
            HStack(spacing: 0) {
                if let leadingActions = leadingActions {
                    leadingActions
                        .frame(width: abs(min(offset, 0)))
                        .clipped()
                }

                Spacer()

                if let trailingActions = trailingActions {
                    trailingActions
                        .frame(width: max(offset, 0))
                        .clipped()
                }
            }

            content
                .offset(x: offset)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            offset = value.translation.width
                        }
                        .onEnded { value in
                            isDragging = false
                            withAnimation(.spring()) {
                                if abs(offset) > 80 {
                                    offset = offset > 0 ? 150 : -150
                                } else {
                                    offset = 0
                                }
                            }
                        }
                )
        }
    }
}

extension SwipeableView where LeadingActions == EmptyView {
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder trailingActions: () -> TrailingActions
    ) {
        self.content = content()
        self.leadingActions = nil
        self.trailingActions = trailingActions()
    }
}

extension SwipeableView where TrailingActions == EmptyView {
    public init(
        @ViewBuilder content: () -> Content,
        @ViewBuilder leadingActions: () -> LeadingActions
    ) {
        self.content = content()
        self.leadingActions = leadingActions()
        self.trailingActions = nil
    }
}

#Preview {
    List {
        SwipeableView(
            content: {
                HStack {
                    Image(systemName: "envelope.fill")
                        .foregroundColor(.blue)
                    VStack(alignment: .leading) {
                        Text("John Doe")
                            .fontWeight(.semibold)
                        Text("Hello, how are you?")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            },
            trailingActions: {
                HStack(spacing: 0) {
                    Button(action: { print("Archive") }) {
                        VStack {
                            Image(systemName: "archivebox.fill")
                            Text("Archive")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 75)
                        .frame(maxHeight: .infinity)
                        .background(Color.orange)
                    }
                    .buttonStyle(LabelButtonStyle())

                    Button(action: { print("Delete") }) {
                        VStack {
                            Image(systemName: "trash.fill")
                            Text("Delete")
                                .font(.caption)
                        }
                        .foregroundColor(.white)
                        .frame(width: 75)
                        .frame(maxHeight: .infinity)
                        .background(Color.red)
                    }
                    .buttonStyle(LabelButtonStyle())
                }
            }
        )

        SwipeableView(
            content: {
                HStack {
                    Image(systemName: "message.fill")
                        .foregroundColor(.green)
                    VStack(alignment: .leading) {
                        Text("Jane Smith")
                            .fontWeight(.semibold)
                        Text("See you tomorrow!")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
            },
            leadingActions: {
                Button(action: { print("Mark as Read") }) {
                    VStack {
                        Image(systemName: "envelope.open.fill")
                        Text("Read")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .frame(width: 75)
                    .frame(maxHeight: .infinity)
                    .background(Color.blue)
                }
                .buttonStyle(LabelButtonStyle())
            },
            trailingActions: {
                Button(action: { print("Delete") }) {
                    VStack {
                        Image(systemName: "trash.fill")
                        Text("Delete")
                            .font(.caption)
                    }
                    .foregroundColor(.white)
                    .frame(width: 75)
                    .frame(maxHeight: .infinity)
                    .background(Color.red)
                }
                .buttonStyle(LabelButtonStyle())
            }
        )
    }
    .listStyle(.plain)
}
