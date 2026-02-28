import SwiftUI

struct DayView: View {
    @State private var currentDate: Date = Date()
    @State private var selectedExercise: Exercise?
    @State private var selectedExerciseIndex: Int = 0
    @State private var showCelebration: Bool = false
    @State private var opacity: Double = 0
    @State private var daySwipeOffset: CGFloat = 0
    @State private var isDayNavigating: Bool = false
    @State private var isDaySwipeActive: Bool = false
    @State private var isDayScrollLocked: Bool = false
    @State private var swipeConsumedTouch: Bool = false
    @State private var incomingDate: Date? = nil
    @State private var incomingOffsetSign: CGFloat = 1
    @State private var navigationGeneration: Int = 0

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

    private func routineFor(date: Date) -> DayRoutine? {
        let dow = Calendar.current.component(.weekday, from: date) - 1
        return getRoutineForDay(dow)
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
                .simultaneousGesture(dayNavigationGesture)

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
            header

            ZStack {
                if let incoming = incomingDate {
                    contentGroup(for: incoming)
                        .offset(x: daySwipeOffset + incomingOffsetSign * UIScreen.main.bounds.width)
                        .allowsHitTesting(false)
                }
                contentGroup(for: currentDate)
                    .offset(x: daySwipeOffset)
            }
            .clipped()
        }
    }

    @ViewBuilder
    private func contentGroup(for date: Date) -> some View {
        if routineFor(date: date)?.isRestDay == true {
            RestDay(dayName: date.formatted(.dateTime.weekday(.wide)))
        } else {
            exerciseList(for: date)
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

    private func exerciseList(for date: Date) -> some View {
        let r = routineFor(date: date)
        let completed = storage.getCompletedCount(for: date)
        let total = r?.exercises.count ?? 0
        return ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                // Title row with progress badge
                HStack {
                    Text(r?.name ?? "")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.appText)

                    Spacer()

                    Text("\(completed)/\(total)")
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
                if completed > 0 {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.appSurface)
                        .frame(height: 4)
                        .overlay(alignment: .leading) {
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(Color.appPrimary)
                                    .frame(width: geo.size.width * min(CGFloat(completed) / CGFloat(total), 1.0), height: 4)
                                    .animation(.easeInOut(duration: 0.3), value: completed)
                            }
                        }
                        .padding(.horizontal, 16)
                }

                // Exercise cards
                VStack(spacing: 16) {
                    if let exercises = r?.exercises {
                        ForEach(Array(exercises.enumerated()), id: \.element.id) { index, exercise in
                            let isCompleted = storage.isExerciseCompleted(exercise.id, for: date)
                            let loggedExercise = storage.getLoggedExercise(exercise.id, for: date)

                            Button {
                                guard !swipeConsumedTouch else { return }
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
        .scrollDisabled(isDaySwipeActive)
    }

    private func navigateDay(by days: Int) {
        guard !isDayNavigating else { return }
        commitDayNavigation(days: days)
    }

    private func commitDayNavigation(days: Int) {
        guard let newDate = Calendar.current.date(byAdding: .day, value: days, to: currentDate) else { return }
        isDayNavigating = true
        incomingDate = newDate
        incomingOffsetSign = days > 0 ? 1 : -1
        let screenWidth = UIScreen.main.bounds.width
        let targetOffset: CGFloat = days > 0 ? -screenWidth : screenWidth
        navigationGeneration += 1
        let generation = navigationGeneration

        withAnimation(.easeInOut(duration: 0.35)) {
            daySwipeOffset = targetOffset
        } completion: {
            guard navigationGeneration == generation else { return }
            currentDate = newDate
            incomingDate = nil
            daySwipeOffset = 0
            isDayNavigating = false
        }
    }

    private var dayNavigationGesture: some Gesture {
        DragGesture(minimumDistance: 15)
            .onChanged { value in
                let h = value.translation.width
                let v = value.translation.height

                if !isDaySwipeActive && !isDayScrollLocked {
                    // New gesture started while a navigation animation is in progress:
                    // snap it to its final state so the new gesture begins cleanly.
                    if isDayNavigating {
                        navigationGeneration += 1
                        isDayNavigating = false
                        currentDate = incomingDate ?? currentDate
                        incomingDate = nil
                        withAnimation(nil) { daySwipeOffset = 0 }
                    }

                    if abs(v) > abs(h) {
                        isDayScrollLocked = true   // vertical won — lock out horizontal
                        return
                    }
                    // Require h:v ratio > 2.4:1 (≈ ±22.5° from horizontal, a 45° total cone)
                    guard abs(h) > abs(v) * 2.4 && abs(h) > 10 else { return }
                    isDaySwipeActive = true        // horizontal won — lock out vertical
                    swipeConsumedTouch = true
                    incomingOffsetSign = h > 0 ? -1 : 1
                    incomingDate = Calendar.current.date(byAdding: .day, value: h > 0 ? -1 : 1, to: currentDate)
                }

                guard isDaySwipeActive else { return }
                let screenWidth = UIScreen.main.bounds.width
                withAnimation(nil) {
                    daySwipeOffset = max(-screenWidth, min(screenWidth, h))
                }
            }
            .onEnded { value in
                // Snapshot before clearing — needed to gate navigation below
                let wasSwipeActive = isDaySwipeActive
                isDaySwipeActive = false
                isDayScrollLocked = false
                DispatchQueue.main.async { swipeConsumedTouch = false }
                // Only commit or snap-back if this gesture was actually a horizontal swipe
                guard wasSwipeActive, !isDayNavigating else { return }
                let h = value.translation.width
                let predicted = value.predictedEndTranslation.width
                if abs(h) > 50 || abs(predicted) > 200 {
                    commitDayNavigation(days: h > 0 ? -1 : 1)
                } else {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.75)) {
                        daySwipeOffset = 0
                    } completion: {
                        incomingDate = nil
                    }
                }
            }
    }

    private func handleExerciseSave() {
        guard let exercises = routine?.exercises,
              selectedExerciseIndex < exercises.count else {
            withAnimation(.easeInOut(duration: 0.3)) { selectedExercise = nil }
            return
        }

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
