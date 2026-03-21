import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise
    let isCompleted: Bool
    let loggedExercise: LoggedExercise?
    let date: Date

    @EnvironmentObject var storage: StorageManager

    var body: some View {
        HStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                CachedAsyncImage(
                    url: URL(string: exercise.images.first ?? ""),
                    content: { image in
                        image.resizable().aspectRatio(contentMode: .fill)
                    },
                    placeholder: { placeholderImage }
                )
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
            let (d, t) = getLastRunValues(for: exercise, on: date, storage: storage)
            return String(format: "%.1f mi \u{00B7} %d min", d, t)
        }
        if exercise.isTimedOnly {
            if let t = loggedExercise?.timeMinutes {
                return "\(t) mins"
            }
            let t = getLastTimedValues(for: exercise, on: date, storage: storage)
            return "\(t) mins"
        }
        if let logged = loggedExercise {
            if logged.weightUsed > 0 {
                return "\(logged.weightUsed) lbs \u{00B7} \(logged.setsCompleted) sets \u{00D7} \(logged.repsCompleted)"
            }
            return "\(logged.setsCompleted) sets \u{00D7} \(logged.repsCompleted)"
        }
        let (weight, sets, reps) = getLastWeekValues(for: exercise, on: date, storage: storage)
        if weight > 0 {
            return "\(weight) lbs \u{00B7} \(sets) sets \u{00D7} \(reps)"
        }
        return "\(sets) sets \u{00D7} \(reps)"
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        VStack(spacing: 16) {
            ExerciseCard(
                exercise: weeklyRoutine[1].exercises[0],
                isCompleted: false,
                loggedExercise: nil,
                date: Date()
            )
            ExerciseCard(
                exercise: weeklyRoutine[1].exercises[0],
                isCompleted: true,
                loggedExercise: LoggedExercise(
                    exerciseId: "squats", weightUsed: 45,
                    setsCompleted: 4, repsCompleted: 6,
                    distanceMiles: nil, timeMinutes: nil,
                    timestamp: Date()
                ),
                date: Date()
            )
        }
        .padding()
    }
    .environmentObject(StorageManager.shared)
}
