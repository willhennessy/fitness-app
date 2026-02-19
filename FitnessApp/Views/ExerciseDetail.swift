import SwiftUI

struct ExerciseDetail: View {
    let exercise: Exercise
    let date: Date
    let isLastExercise: Bool
    let onSave: () -> Void
    let onBack: () -> Void

    @EnvironmentObject var storage: StorageManager

    @State private var weight: Int = 0
    @State private var sets: Int = 0
    @State private var reps: Int = 10
    @State private var distance: Double = 3.1
    @State private var time: Int = 31
    @State private var isSaved: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    onBack()
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Back")
                            .font(.system(size: 17))
                    }
                    .foregroundColor(.appPrimary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Image
                    CachedAsyncImage(
                        url: URL(string: exercise.images.first ?? ""),
                        content: { image in
                            image.resizable().aspectRatio(16/9, contentMode: .fill)
                        },
                        placeholder: { placeholderImage }
                    )
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)

                    // Title
                    Text(exercise.name)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.appText)
                        .padding(.horizontal, 16)

                    // Input Section
                    VStack(spacing: 0) {
                        if exercise.isRun {
                            DoubleWorkoutStepper(
                                label: "Distance",
                                value: $distance,
                                range: 0.1...26.2,
                                step: 0.1,
                                format: { String(format: "%.1f mi", $0) }
                            )

                            Divider()
                                .background(Color.appBorder)
                                .padding(.horizontal, 16)

                            WorkoutStepper(label: "Time (min)", value: $time, range: 1...180, step: 1)
                        } else {
                            WorkoutStepper(label: "Weight", value: $weight, range: 0...500, step: 5)

                            Divider()
                                .background(Color.appBorder)
                                .padding(.horizontal, 16)

                            WorkoutStepper(label: "Reps", value: $reps, range: 1...100, step: 1)

                            Divider()
                                .background(Color.appBorder)
                                .padding(.horizontal, 16)

                            WorkoutStepper(label: "Sets", value: $sets, range: 1...20, step: 1)
                        }
                    }
                    .background(Color.appSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .padding(.horizontal, 16)

                    // Save Button
                    Button {
                        saveExercise()
                    } label: {
                        HStack(spacing: 8) {
                            if isSaved {
                                Image(systemName: "checkmark")
                                    .font(.system(size: 16, weight: .semibold))
                                Text("Done")
                                    .font(.system(size: 17, weight: .semibold))
                            } else {
                                Text("Done")
                                    .font(.system(size: 17, weight: .semibold))
                            }
                        }
                        .foregroundColor(isSaved ? .appPrimary : .appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isSaved ? Color.appSurface : Color.appPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .padding(.horizontal, 16)

                    // Cues Section
                    if !exercise.cues.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("CUES")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.appTextMuted)
                                .tracking(1)

                            VStack(alignment: .leading, spacing: 10) {
                                ForEach(exercise.cues, id: \.self) { cue in
                                    HStack(alignment: .top, spacing: 12) {
                                        Circle()
                                            .fill(Color.appPrimary)
                                            .frame(width: 6, height: 6)
                                            .padding(.top, 6)

                                        Text(cue)
                                            .font(.system(size: 16))
                                            .foregroundColor(.appText)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Why Section
                    if !exercise.why.isEmpty {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("WHY THIS EXERCISE?")
                                .font(.system(size: 12, weight: .semibold))
                                .foregroundColor(.appTextMuted)
                                .tracking(1)

                            Text(exercise.why)
                                .font(.system(size: 16))
                                .foregroundColor(.appText)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 16)
                    }

                    Spacer(minLength: 32)
                }
                .padding(.top, 8)
            }
        }
        .background(Color.appBackground)
        .onAppear {
            loadValues()
        }
    }

    private var placeholderImage: some View {
        ZStack {
            Color.appSurface
            Image(systemName: "photo")
                .font(.system(size: 48))
                .foregroundColor(.appTextMuted)
        }
        .aspectRatio(16/9, contentMode: .fill)
    }

    private func loadValues() {
        if exercise.isRun {
            if let logged = storage.getLoggedExercise(exercise.id, for: date),
               let d = logged.distanceMiles, let t = logged.timeMinutes {
                distance = d
                time = t
                isSaved = true
            } else {
                let (d, t) = getLastRunValues(for: exercise, on: date, storage: storage)
                distance = d
                time = t
                isSaved = false
            }
            return
        }

        // Check if already logged today
        if let logged = storage.getLoggedExercise(exercise.id, for: date) {
            weight = logged.weightUsed
            sets = logged.setsCompleted
            reps = logged.repsCompleted
            isSaved = true
            return
        }

        // Get last week's values or defaults
        let (w, s, r) = getLastWeekValues(for: exercise, on: date, storage: storage)
        weight = w
        sets = s
        reps = r
        isSaved = false
    }

    private func saveExercise() {
        let logged: LoggedExercise
        if exercise.isRun {
            logged = LoggedExercise(
                exerciseId: exercise.id,
                weightUsed: 0,
                setsCompleted: 0,
                repsCompleted: 0,
                distanceMiles: distance,
                timeMinutes: time,
                timestamp: Date()
            )
        } else {
            logged = LoggedExercise(
                exerciseId: exercise.id,
                weightUsed: weight,
                setsCompleted: sets,
                repsCompleted: reps,
                distanceMiles: nil,
                timeMinutes: nil,
                timestamp: Date()
            )
        }

        storage.logExercise(logged, for: date)
        isSaved = true

        // Auto-advance after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            onSave()
        }
    }
}

#Preview {
    ExerciseDetail(
        exercise: weeklyRoutine[1].exercises[0],
        date: Date(),
        isLastExercise: false,
        onSave: {},
        onBack: {}
    )
    .environmentObject(StorageManager.shared)
}
