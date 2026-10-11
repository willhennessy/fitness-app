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
    if let logged = typicalLoggedExercise(for: exercise, on: date, entries: storage.getEntries()),
       let distance = logged.distanceMiles,
       let time = logged.timeMinutes {
        return (distance, time)
    }

    return (3.1, 31)
}


func getLastTimedValues(for exercise: Exercise, on date: Date, storage: StorageManager) -> Int {
    if let logged = typicalLoggedExercise(for: exercise, on: date, entries: storage.getEntries()),
       let time = logged.timeMinutes {
        return time
    }

    return parseReps(exercise.reps)
}

func getLastWeekValues(for exercise: Exercise, on date: Date, storage: StorageManager) -> (weight: Int, sets: Int, reps: Int) {
    if let logged = typicalLoggedExercise(for: exercise, on: date, entries: storage.getEntries()) {
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

private enum WorkoutSignature: Hashable {
    case strength(weight: Int, sets: Int, reps: Int)
    case run(distance: Double, minutes: Int)
    case timed(minutes: Int)
}

/// Most frequent completed workout across prior dates, with ties favoring the
/// most recent session. Preserve an actual workout tuple rather than mixing fields.
/// Zero added weight is valid for bodyweight work; zero sets/reps/duration is skipped.
func typicalLoggedExercise(for exercise: Exercise, on date: Date, entries: [DayEntry]) -> LoggedExercise? {
    let cutoff = formatISO(date)
    var groups: [WorkoutSignature: (count: Int, date: String, logged: LoggedExercise)] = [:]

    for entry in entries where entry.date < cutoff {
        for logged in entry.exercises where logged.exerciseId == exercise.id {
            let signature: WorkoutSignature
            if exercise.isRun {
                guard let distance = logged.distanceMiles, distance.isFinite, distance > 0,
                      let minutes = logged.timeMinutes, minutes > 0 else { continue }
                signature = .run(distance: distance, minutes: minutes)
            } else if exercise.isTimedOnly {
                guard let minutes = logged.timeMinutes, minutes > 0 else { continue }
                signature = .timed(minutes: minutes)
            } else {
                guard logged.weightUsed >= 0, logged.setsCompleted > 0,
                      logged.repsCompleted > 0 else { continue }
                signature = .strength(weight: logged.weightUsed, sets: logged.setsCompleted, reps: logged.repsCompleted)
            }

            if var group = groups[signature] {
                group.count += 1
                if entry.date > group.date || (entry.date == group.date && logged.timestamp > group.logged.timestamp) {
                    group.date = entry.date
                    group.logged = logged
                }
                groups[signature] = group
            } else {
                groups[signature] = (1, entry.date, logged)
            }
        }
    }

    return groups.values.max { lhs, rhs in
        if lhs.count != rhs.count { return lhs.count < rhs.count }
        if lhs.date != rhs.date { return lhs.date < rhs.date }
        return lhs.logged.timestamp < rhs.logged.timestamp
    }?.logged
}
