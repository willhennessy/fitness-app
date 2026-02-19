import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise
    let isCompleted: Bool
    let loggedExercise: LoggedExercise?

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                AsyncImage(url: URL(string: exercise.images.first ?? "")) { phase in
                    switch phase {
                    case .empty:
                        placeholderImage
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    case .failure:
                        placeholderImage
                    @unknown default:
                        placeholderImage
                    }
                }
                .frame(width: 64, height: 64)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                if isCompleted {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 18))
                        .foregroundColor(.appPrimary)
                        .background(Circle().fill(Color.appBackground).padding(2))
                        .offset(x: 4, y: -4)
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(exercise.name)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
                    .lineLimit(2)

                Text(subtitleText)
                    .font(.system(size: 14))
                    .foregroundColor(.appTextMuted)
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.appTextMuted)
        }
        .padding(12)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .opacity(isCompleted ? 0.5 : 1.0)
    }

    private var placeholderImage: some View {
        ZStack {
            Color.appSurfaceHover
            Image(systemName: "photo")
                .font(.system(size: 24))
                .foregroundColor(.appTextMuted)
        }
    }

    private var subtitleText: String {
        if exercise.isRun {
            if let d = loggedExercise?.distanceMiles, let t = loggedExercise?.timeMinutes {
                return String(format: "%.1f mi \u{00B7} %d min", d, t)
            }
            return "5k (3.1 miles) \u{00B7} 30 min"
        }
        if let weight = loggedExercise?.weightUsed, weight > 0 {
            return "\(weight) lbs \u{00B7} \(exercise.sets) sets \u{00D7} \(exercise.reps)"
        }
        return "\(exercise.sets) sets \u{00D7} \(exercise.reps)"
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        VStack(spacing: 16) {
            ExerciseCard(
                exercise: weeklyRoutine[1].exercises[0],
                isCompleted: false,
                loggedExercise: nil
            )
            ExerciseCard(
                exercise: weeklyRoutine[1].exercises[0],
                isCompleted: true,
                loggedExercise: LoggedExercise(
                    exerciseId: "squats", weightUsed: 45,
                    setsCompleted: 4, repsCompleted: 6,
                    distanceMiles: nil, timeMinutes: nil,
                    timestamp: Date()
                )
            )
        }
        .padding()
    }
}
