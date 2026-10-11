// Compile with Exercise.swift, LoggedExercise.swift, DayEntry.swift,
// DayRoutine.swift, Routine.swift, and DateHelpers.swift (no app storage writes).
import Foundation

final class StorageManager {
    let entries: [DayEntry]
    init(_ entries: [DayEntry]) { self.entries = entries }
    func getEntries() -> [DayEntry] { entries }
}

@main struct WorkoutDefaultsTests {
    static func main() {
        let date = Calendar.current.date(from: DateComponents(year: 2026, month: 10, day: 15))!
        let strength = Exercise(id: "test", name: "Test", sets: 2, reps: "8-10", images: [], cues: [], why: "")
        let timed = Exercise(id: "test", name: "Walk", sets: 1, reps: "20-30 min", images: [], cues: [], why: "", isTimedOnly: true)
        let run = Exercise(id: "test", name: "Run", sets: 1, reps: "", images: [], cues: [], why: "", isRun: true)
        func entry(_ day: String, _ weight: Int = 50, _ sets: Int = 3, _ reps: Int = 10, distance: Double? = nil, minutes: Int? = nil, id: String = "test") -> DayEntry {
            DayEntry(date: day, dayOfWeek: 0, exercises: [LoggedExercise(exerciseId: id, weightUsed: weight, setsCompleted: sets, repsCompleted: reps, distanceMiles: distance, timeMinutes: minutes, timestamp: date)])
        }
        func defaults(_ entries: [DayEntry]) -> (Int, Int, Int) {
            getLastWeekValues(for: strength, on: date, storage: StorageManager(entries))
        }
        // Older, different-weekday sessions count; newer skipped rows do not.
        let history = [entry("2026-01-01"), entry("2026-02-03"), entry("2026-10-13", 75, 4, 8), entry("2026-10-14", 0, 0, 0)]
        assert(defaults(history) == (50, 3, 10))
        assert(defaults(history.reversed()) == (50, 3, 10))
        // Ties choose the newest actual tuple, never field-by-field averages.
        assert(defaults([entry("2026-01-01"), entry("2026-10-13", 75, 4, 8)]) == (75, 4, 8))
        assert(defaults([entry("2026-10-13", 0, 3, 12)]) == (0, 3, 12))
        assert(defaults([entry("2026-10-13", 50, 0, 12), entry("2026-10-14", 50, 3, 0)]) == (0, 2, 9))
        assert(defaults([entry("2026-10-15"), entry("2026-10-16"), entry("2026-10-13", id: "other")]) == (0, 2, 9))
        assert(defaults([]) == (0, 2, 9))
        let times = [entry("2026-01-01", minutes: 30), entry("2026-02-03", minutes: 30), entry("2026-10-13", minutes: 20), entry("2026-10-14", minutes: 0)]
        assert(getLastTimedValues(for: timed, on: date, storage: StorageManager(times)) == 30)
        assert(getLastTimedValues(for: timed, on: date, storage: StorageManager([])) == 25)
        let runs = [entry("2026-01-01", distance: 4, minutes: 40), entry("2026-02-03", distance: 4, minutes: 40), entry("2026-10-13", distance: 5, minutes: 50), entry("2026-10-14", distance: 0, minutes: 0)]
        let actualRun = getLastRunValues(for: run, on: date, storage: StorageManager(runs))
        assert(actualRun.distance == 4 && actualRun.time == 40)
        assert(getLastRunValues(for: run, on: date, storage: StorageManager([entry("2026-10-13", distance: .infinity, minutes: 5)])).distance == 3.1)
        let thursday = weeklyRoutine.first { $0.dayOfWeek == 4 }!
        let split = thursday.exercises[3]
        assert(split.id == "bulgarian-split-squat" && split.sets == 2 && split.reps == "8-10 per leg")
        assert(weeklyRoutine.allSatisfy { !$0.name.contains(" min") })
        assert(weeklyRoutine[0].exercises[3].id == "romanian-deadlift")
        assert(weeklyRoutine[2].exercises[1].id == "walking-lunge")
        print("PASS: history defaults, skipped entries, bodyweight, ties, dates, isolation, fallbacks, timed/run values, and routine changes")
    }
}
