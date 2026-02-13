import SwiftUI

struct WorkoutStepper: View {
    let label: String
    @Binding var value: Int
    let range: ClosedRange<Int>
    let step: Int

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 17))
                .foregroundColor(.appText)

            Spacer()

            HStack(spacing: 16) {
                Button {
                    if value - step >= range.lowerBound {
                        value -= step
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(value <= range.lowerBound ? .appTextMuted : .appPrimary)
                        .frame(width: 36, height: 36)
                        .background(Color.appSurfaceHover)
                        .clipShape(Circle())
                }
                .disabled(value <= range.lowerBound)

                Text("\(value)")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.appText)
                    .frame(minWidth: 40)

                Button {
                    if value + step <= range.upperBound {
                        value += step
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(value >= range.upperBound ? .appTextMuted : .appPrimary)
                        .frame(width: 36, height: 36)
                        .background(Color.appSurfaceHover)
                        .clipShape(Circle())
                }
                .disabled(value >= range.upperBound)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        WorkoutStepper(label: "Weight", value: .constant(45), range: 0...500, step: 5)
    }
}
