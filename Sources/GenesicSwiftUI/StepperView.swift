import SwiftUI

public struct StepperView: View {
    let steps: [String]
    let currentStep: Int
    let color: Color

    public init(
        steps: [String],
        currentStep: Int,
        color: Color = .blue
    ) {
        self.steps = steps
        self.currentStep = currentStep
        self.color = color
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<steps.count, id: \.self) { index in
                HStack(spacing: 12) {
                    // Step indicator
                    ZStack {
                        Circle()
                            .fill(stepColor(for: index))
                            .frame(width: 32, height: 32)

                        if index < currentStep {
                            Image(systemName: "checkmark")
                                .foregroundColor(.white)
                                .font(.system(size: 14, weight: .bold))
                        } else {
                            Text("\(index + 1)")
                                .foregroundColor(index == currentStep ? .white : .secondary)
                                .font(.system(size: 14, weight: .bold))
                        }
                    }

                    // Step text
                    Text(steps[index])
                        .font(.subheadline)
                        .fontWeight(index == currentStep ? .semibold : .regular)
                        .foregroundColor(index <= currentStep ? .primary : .secondary)

                    Spacer()
                }

                // Connector line
                if index < steps.count - 1 {
                    Rectangle()
                        .fill(index < currentStep ? color : Color(.systemGray4))
                        .frame(width: 2, height: 24)
                        .offset(x: 15)
                }
            }
        }
    }

    private func stepColor(for index: Int) -> Color {
        if index < currentStep {
            return color
        } else if index == currentStep {
            return color
        } else {
            return Color(.systemGray4)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        VStack(alignment: .leading, spacing: 12) {
            Text("Order Process")
                .font(.headline)

            StepperView(
                steps: ["Cart", "Shipping", "Payment", "Confirmation"],
                currentStep: 1
            )
        }

        VStack(alignment: .leading, spacing: 12) {
            Text("Account Setup")
                .font(.headline)

            StepperView(
                steps: ["Personal Info", "Contact Details", "Verification", "Complete"],
                currentStep: 2,
                color: .green
            )
        }
    }
    .padding()
}
