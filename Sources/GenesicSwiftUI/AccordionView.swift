import SwiftUI

public struct AccordionView<Content: View>: View {
    let title: String
    let icon: String?
    @Binding var isExpanded: Bool
    let content: Content

    public init(
        title: String,
        icon: String? = nil,
        isExpanded: Binding<Bool>,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self._isExpanded = isExpanded
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    isExpanded.toggle()
                }
            }) {
                HStack {
                    if let icon = icon {
                        Image(systemName: icon)
                            .foregroundColor(.blue)
                    }

                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)

                    Spacer()

                    Image(systemName: "chevron.right")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding()
                .background(Color(.systemGray6))
            }
            .buttonStyle(LabelButtonStyle())

            if isExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    content
                        .padding()
                }
                .background(Color(.systemBackground))
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: .black.opacity(0.05), radius: 5)
    }
}

#Preview {
    struct AccordionPreview: View {
        @State private var section1Expanded = true
        @State private var section2Expanded = false
        @State private var section3Expanded = false

        var body: some View {
            ScrollView {
                VStack(spacing: 16) {
                    AccordionView(
                        title: "Personal Information",
                        icon: "person.fill",
                        isExpanded: $section1Expanded
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            InfoRow(label: "Name", value: "John Doe")
                            InfoRow(label: "Email", value: "john@example.com")
                            InfoRow(label: "Phone", value: "+1 234 567 8900")
                        }
                    }

                    AccordionView(
                        title: "Shipping Address",
                        icon: "location.fill",
                        isExpanded: $section2Expanded
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("123 Main Street")
                            Text("Apartment 4B")
                            Text("New York, NY 10001")
                            Text("United States")
                        }
                        .font(.body)
                        .foregroundColor(.secondary)
                    }

                    AccordionView(
                        title: "Payment Methods",
                        icon: "creditcard.fill",
                        isExpanded: $section3Expanded
                    ) {
                        VStack(alignment: .leading, spacing: 12) {
                            PaymentMethodRow(type: "Visa", last4: "4242")
                            PaymentMethodRow(type: "Mastercard", last4: "5555")
                        }
                    }
                }
                .padding()
            }
        }

        struct InfoRow: View {
            let label: String
            let value: String

            var body: some View {
                HStack {
                    Text(label)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(value)
                        .fontWeight(.medium)
                }
            }
        }

        struct PaymentMethodRow: View {
            let type: String
            let last4: String

            var body: some View {
                HStack {
                    Image(systemName: "creditcard.fill")
                        .foregroundColor(.blue)
                    Text("\(type) •••• \(last4)")
                    Spacer()
                }
            }
        }
    }

    return AccordionPreview()
}
