import Foundation

func formatISO(_ date: Date) -> String {
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions = [.withFullDate]
    return formatter.string(from: date)
}

func startOfDay(_ date: Date) -> Date {
    Calendar.current.startOfDay(for: date)
}

func relativeDayName(for date: Date) -> String {
    let calendar = Calendar.current
    let today = startOfDay(Date())
    let targetDay = startOfDay(date)
    let diff = calendar.dateComponents([.day], from: today, to: targetDay).day ?? 0
    let dayName = date.formatted(.dateTime.weekday(.wide))

    switch diff {
    case 0:
        return "Today"
    case -1:
        return "Yesterday"
    case 1:
        return "Tomorrow"
    case -7...(-2):
        return "Last \(dayName)"
    case 2...6:
        return dayName
    case 7...13:
        return "Next \(dayName)"
    default:
        return date.formatted(.dateTime.weekday(.wide).month(.abbreviated).day())
    }
}

func parseReps(_ reps: String) -> Int {
    let numbers = reps.components(separatedBy: CharacterSet.decimalDigits.inverted)
        .compactMap { Int($0) }

    if numbers.count >= 2 {
        return (numbers[0] + numbers[1]) / 2
    }
    return numbers.first ?? 10
}

func getLastRunValues(for exercise: Exercise, on date: Date, storage: StorageManager) -> (distance: Double, time: Int) {
    let calendar = Calendar.current

    for weeksBack in 1...4 {
        if let pastDate = calendar.date(byAdding: .weekOfYear, value: -weeksBack, to: date) {
            let pastDateISO = formatISO(pastDate)

            if let entry = storage.getEntry(for: pastDateISO),
               let logged = entry.exercises.first(where: { $0.exerciseId == exercise.id }),
               let distance = logged.distanceMiles,
               let time = logged.timeMinutes {
                return (distance, time)
            }
        }
    }

    return (3.1, 31)
}

func getLastWeekValues(for exercise: Exercise, on date: Date, storage: StorageManager) -> (weight: Int, sets: Int, reps: Int) {
    let calendar = Calendar.current

    for weeksBack in 1...4 {
        if let pastDate = calendar.date(byAdding: .weekOfYear, value: -weeksBack, to: date) {
            let pastDateISO = formatISO(pastDate)

            if let entry = storage.getEntry(for: pastDateISO),
               let logged = entry.exercises.first(where: { $0.exerciseId == exercise.id }) {
                return (logged.weightUsed, logged.setsCompleted, logged.repsCompleted)
            }
        }
    }

    return (0, exercise.sets, parseReps(exercise.reps))
}
