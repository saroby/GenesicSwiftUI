import SwiftUI

public struct BottomSheetView<Content: View>: View {
    @Binding var isPresented: Bool
    let content: Content
    let maxHeight: CGFloat

    public init(
        isPresented: Binding<Bool>,
        maxHeight: CGFloat = UIScreen.main.bounds.height * 0.8,
        @ViewBuilder content: () -> Content
    ) {
        self._isPresented = isPresented
        self.maxHeight = maxHeight
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            if isPresented {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        withAnimation {
                            isPresented = false
                        }
                    }

                VStack(spacing: 0) {
                    // Handle
                    RoundedRectangle(cornerRadius: 3)
                        .fill(Color(.systemGray4))
                        .frame(width: 40, height: 5)
                        .padding(.top, 12)
                        .padding(.bottom, 8)

                    ScrollView {
                        content
                            .padding()
                    }
                }
                .frame(maxHeight: maxHeight)
                .background(Color(.systemBackground))
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .transition(.move(edge: .bottom))
            }
        }
        .animation(.spring(), value: isPresented)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

#Preview {
    struct BottomSheetPreview: View {
        @State private var showSheet = false

        var body: some View {
            ZStack {
                VStack {
                    Button("Show Bottom Sheet") {
                        showSheet = true
                    }
                    .buttonStyle(PrimaryButtonStyle())
                }

                BottomSheetView(isPresented: $showSheet) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Bottom Sheet Title")
                            .font(.title2)
                            .fontWeight(.bold)

                        Text("This is a bottom sheet component. It slides up from the bottom of the screen and can contain any content you want.")
                            .foregroundColor(.secondary)

                        VStack(spacing: 12) {
                            ForEach(0..<5, id: \.self) { index in
                                HStack {
                                    Image(systemName: "\(index + 1).circle.fill")
                                        .foregroundColor(.blue)
                                    Text("Option \(index + 1)")
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.secondary)
                                }
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                            }
                        }

                        Button("Close") {
                            showSheet = false
                        }
                        .buttonStyle(SecondaryButtonStyle(isFullWidth: true))
                    }
                }
            }
        }
    }

    return BottomSheetPreview()
}
