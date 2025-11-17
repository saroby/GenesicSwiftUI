import SwiftUI

public struct CountdownTimer: View {
    let targetDate: Date
    @State private var timeRemaining: TimeInterval = 0
    @State private var timer: Timer?

    public init(targetDate: Date) {
        self.targetDate = targetDate
    }

    public var body: some View {
        HStack(spacing: 12) {
            TimeUnitView(value: days, unit: "Days")
            SeparatorView()
            TimeUnitView(value: hours, unit: "Hours")
            SeparatorView()
            TimeUnitView(value: minutes, unit: "Mins")
            SeparatorView()
            TimeUnitView(value: seconds, unit: "Secs")
        }
        .onAppear {
            updateTimeRemaining()
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                updateTimeRemaining()
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func updateTimeRemaining() {
        timeRemaining = max(0, targetDate.timeIntervalSinceNow)
    }

    private var days: Int {
        Int(timeRemaining) / 86400
    }

    private var hours: Int {
        (Int(timeRemaining) % 86400) / 3600
    }

    private var minutes: Int {
        (Int(timeRemaining) % 3600) / 60
    }

    private var seconds: Int {
        Int(timeRemaining) % 60
    }

    struct TimeUnitView: View {
        let value: Int
        let unit: String

        var body: some View {
            VStack(spacing: 4) {
                Text("\(value)")
                    .font(.title)
                    .fontWeight(.bold)
                    .monospacedDigit()
                    .frame(minWidth: 50)
                    .padding(.vertical, 8)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)

                Text(unit)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }

    struct SeparatorView: View {
        var body: some View {
            Text(":")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondary)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        VStack(spacing: 16) {
            Text("Sale Ends In")
                .font(.title2)
                .fontWeight(.bold)

            CountdownTimer(
                targetDate: Date().addingTimeInterval(3600 * 24 * 3 + 3600 * 5 + 60 * 30 + 45)
            )
        }

        VStack(spacing: 16) {
            Text("Event Starts In")
                .font(.title2)
                .fontWeight(.bold)

            CountdownTimer(
                targetDate: Date().addingTimeInterval(3600 * 24 * 7)
            )
        }
    }
    .padding()
}
