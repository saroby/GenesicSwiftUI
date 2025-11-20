import SwiftUI

public struct ToggleSwitch: View {
    @Binding var isOn: Bool
    let label: String?
    let color: Color

    public init(
        isOn: Binding<Bool>,
        label: String? = nil,
        color: Color = .green
    ) {
        self._isOn = isOn
        self.label = label
        self.color = color
    }

    public var body: some View {
        HStack {
            if let label = label {
                Text(label)
                    .font(.body)
                Spacer()
            }

            Toggle("", isOn: $isOn)
                .labelsHidden()
                .tint(color)
        }
    }
}

public struct CustomToggleSwitch: View {
    @Binding var isOn: Bool
    let onColor: Color
    let offColor: Color
    let thumbColor: Color

    public init(
        isOn: Binding<Bool>,
        onColor: Color = .green,
        offColor: Color = Color(.systemGray5),
        thumbColor: Color = .white
    ) {
        self._isOn = isOn
        self.onColor = onColor
        self.offColor = offColor
        self.thumbColor = thumbColor
    }

    public var body: some View {
        ZStack(alignment: isOn ? .trailing : .leading) {
            RoundedRectangle(cornerRadius: 16)
                .fill(isOn ? onColor : offColor)
                .frame(width: 50, height: 30)

            Circle()
                .fill(thumbColor)
                .frame(width: 26, height: 26)
                .padding(2)
                .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 1)
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                isOn.toggle()
            }
        }
    }
}

#Preview {
    struct ToggleSwitchPreview: View {
        @State private var toggle1 = true
        @State private var toggle2 = false
        @State private var toggle3 = true
        @State private var toggle4 = false
        @State private var toggle5 = true

        var body: some View {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Standard Toggles")
                        .font(.headline)

                    ToggleSwitch(isOn: $toggle1, label: "Notifications")
                    ToggleSwitch(isOn: $toggle2, label: "Dark Mode", color: .blue)
                }

                Divider()

                VStack(alignment: .leading, spacing: 16) {
                    Text("Custom Toggles")
                        .font(.headline)

                    HStack {
                        Text("WiFi")
                        Spacer()
                        CustomToggleSwitch(isOn: $toggle3)
                    }

                    HStack {
                        Text("Bluetooth")
                        Spacer()
                        CustomToggleSwitch(isOn: $toggle4, onColor: .blue)
                    }

                    HStack {
                        Text("Airplane Mode")
                        Spacer()
                        CustomToggleSwitch(isOn: $toggle5, onColor: .orange)
                    }
                }
            }
            .padding()
        }
    }

    return ToggleSwitchPreview()
}
