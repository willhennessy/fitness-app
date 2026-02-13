import SwiftUI

struct RestDay: View {
    let dayName: String

    private let recoveryTips = [
        "Take a gentle walk outside",
        "Foam roll or do light stretching",
        "Focus on hydration and nutrition",
        "Get 7-9 hours of quality sleep",
        "Practice deep breathing or meditation"
    ]

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: "book.closed")
                .font(.system(size: 64))
                .foregroundColor(.appTextMuted)

            Text("Rest Day")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.appText)

            Text("\(dayName) is for recovery. Take it easy, stay hydrated, and get some good sleep.")
                .font(.system(size: 16))
                .foregroundColor(.appTextMuted)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            VStack(alignment: .leading, spacing: 16) {
                Text("Recovery Tips")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.appTextMuted)
                    .textCase(.uppercase)

                VStack(alignment: .leading, spacing: 12) {
                    ForEach(recoveryTips, id: \.self) { tip in
                        HStack(alignment: .top, spacing: 12) {
                            Circle()
                                .fill(Color.appPrimary)
                                .frame(width: 6, height: 6)
                                .padding(.top, 6)

                            Text(tip)
                                .font(.system(size: 16))
                                .foregroundColor(.appText)
                        }
                    }
                }
            }
            .padding(20)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.horizontal, 16)

            Spacer()
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        RestDay(dayName: "Thursday")
    }
}
