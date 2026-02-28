import SwiftUI

struct DayView: View {
    @State private var currentDate: Date = Date()
    @State private var selectedExercise: Exercise?
    @State private var selectedExerciseIndex: Int = 0
    @State private var showCelebration: Bool = false
    @State private var opacity: Double = 0

    @EnvironmentObject var storage: StorageManager

    private var dayOfWeek: Int {
        Calendar.current.component(.weekday, from: currentDate) - 1
    }

    private var routine: DayRoutine? {
        getRoutineForDay(dayOfWeek)
    }

    private var completedCount: Int {
        storage.getCompletedCount(for: currentDate)
    }

    private var totalExercises: Int {
        routine?.exercises.count ?? 0
    }

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            mainContent
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 0.3)) {
                        opacity = 1
                    }
                }
                .allowsHitTesting(selectedExercise == nil)

            if let exercise = selectedExercise {
                ExerciseDetail(
                    exercise: exercise,
                    date: currentDate,
                    isLastExercise: selectedExerciseIndex == totalExercises - 1,
                    onSave: {
                        handleExerciseSave()
                    },
                    onBack: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            selectedExercise = nil
                        }
                    }
                )
                .id(exercise.id)
                .transition(.move(edge: .trailing))
            }

            if showCelebration {
                Celebration {
                    showCelebration = false
                }
            }
        }
    }

    private var mainContent: some View {
        VStack(spacing: 0) {
            // Header
            header

            if routine?.isRestDay == true {
                RestDay(dayName: currentDate.formatted(.dateTime.weekday(.wide)))
            } else {
                exerciseList
            }
        }
    }

    private var header: some View {
        VStack(spacing: 0) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.appPrimary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture { navigateDay(by: -1) }
                    .onLongPressGesture { currentDate = Date() }

                Spacer()

                Text(relativeDayName(for: currentDate))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.appText)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.appPrimary)
                    .frame(width: 44, height: 44)
                    .contentShape(Rectangle())
                    .onTapGesture { navigateDay(by: 1) }
                    .onLongPressGesture { currentDate = Date() }
            }
            .padding(.horizontal, 8)

            Divider()
                .background(Color.appBorder)
        }
    }

    private var exerciseList: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title row with progress badge
                HStack {
                    Text(routine?.name ?? "")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.appText)

                    Spacer()

                    Text("\(completedCount)/\(totalExercises)")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.appTextMuted)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.appSurface)
                        .clipShape(Capsule())
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)

                // Progress bar - only show if at least 1 completed
                if completedCount > 0 {
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.appSurface)
                                .frame(height: 4)

                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.appPrimary)
                                .frame(width: geo.size.width * CGFloat(completedCount) / CGFloat(totalExercises), height: 4)
                                .animation(.easeInOut(duration: 0.3), value: completedCount)
                        }
                    }
                    .frame(height: 4)
                    .padding(.horizontal, 16)
                }

                // Exercise cards
                VStack(spacing: 16) {
                    if let exercises = routine?.exercises {
                        ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                            let isCompleted = storage.isExerciseCompleted(exercise.id, for: currentDate)
                            let loggedExercise = storage.getLoggedExercise(exercise.id, for: currentDate)

                            Button {
                                selectedExerciseIndex = index
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedExercise = exercise
                                }
                            } label: {
                                ExerciseCard(
                                    exercise: exercise,
                                    isCompleted: isCompleted,
                                    loggedExercise: loggedExercise
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
    }

    private func navigateDay(by days: Int) {
        if let newDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate) {
            currentDate = newDate
        }
    }

    private func handleExerciseSave() {
        guard let exercises = routine?.exercises else { return }

        // Check if this was the last exercise
        if selectedExerciseIndex == exercises.count - 1 {
            // Check if all exercises are completed
            let allCompleted = exercises.allSatisfy { exercise in
                storage.isExerciseCompleted(exercise.id, for: currentDate)
            }

            if allCompleted {
                withAnimation {
                    selectedExercise = nil
                    showCelebration = true
                }
                return
            }
        }

        // Find next incomplete exercise
        for i in (selectedExerciseIndex + 1)..<exercises.count {
            if !storage.isExerciseCompleted(exercises[i].id, for: currentDate) {
                selectedExerciseIndex = i
                withAnimation(.easeInOut(duration: 0.3)) {
                    selectedExercise = exercises[i]
                }
                return
            }
        }

        // If no incomplete exercises after current, go back to list
        withAnimation(.easeInOut(duration: 0.3)) {
            selectedExercise = nil
        }
    }
}

#Preview {
    DayView()
        .environmentObject(StorageManager.shared)
}
