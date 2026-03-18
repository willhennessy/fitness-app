import Foundation

func formatISO(_ date: Date) -> String {
    DateFormatting.isoDateFormatter.string(from: date)
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
    if let logged = recentLoggedExercise(for: exercise, on: date, storage: storage),
       let distance = logged.distanceMiles,
       let time = logged.timeMinutes {
        return (distance, time)
    }

    return (3.1, 31)
}


func getLastTimedValues(for exercise: Exercise, on date: Date, storage: StorageManager) -> Int {
    if let logged = recentLoggedExercise(for: exercise, on: date, storage: storage),
       let time = logged.timeMinutes {
        return time
    }

    return parseReps(exercise.reps)
}

func getLastWeekValues(for exercise: Exercise, on date: Date, storage: StorageManager) -> (weight: Int, sets: Int, reps: Int) {
    if let logged = recentLoggedExercise(for: exercise, on: date, storage: storage) {
        return (logged.weightUsed, logged.setsCompleted, logged.repsCompleted)
    }

    return (0, exercise.sets, parseReps(exercise.reps))
}

private enum DateFormatting {
    static let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        formatter.timeZone = .autoupdatingCurrent
        return formatter
    }()
}

private func recentLoggedExercise(for exercise: Exercise, on date: Date, storage: StorageManager) -> LoggedExercise? {
    let calendar = Calendar.current

    for weeksBack in 1...4 {
        guard let pastDate = calendar.date(byAdding: .weekOfYear, value: -weeksBack, to: date) else {
            continue
        }

        let pastDateISO = formatISO(pastDate)
        if let entry = storage.getEntry(for: pastDateISO),
           let logged = entry.exercises.first(where: { $0.exerciseId == exercise.id }) {
            return logged
        }
    }

    return nil
}
