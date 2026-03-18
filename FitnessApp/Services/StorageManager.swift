import Foundation

class StorageManager: ObservableObject {
    static let shared = StorageManager()
    private let key = "fitness-app-data"
    private var entryIndexByDate: [String: Int] = [:]

    @Published private(set) var entries: [DayEntry] = []

    private init() {
        entries = loadEntries()
        rebuildIndex()
    }

    private func loadEntries() -> [DayEntry] {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([DayEntry].self, from: data) else {
            return []
        }
        return decoded
    }

    func getEntries() -> [DayEntry] {
        entries
    }

    func saveEntry(_ entry: DayEntry) {
        if let index = entryIndexByDate[entry.date] {
            entries[index] = entry
        } else {
            entries.append(entry)
            entryIndexByDate[entry.date] = entries.count - 1
        }
        if let data = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    func getEntry(for date: String) -> DayEntry? {
        guard let index = entryIndexByDate[date], entries.indices.contains(index) else {
            return nil
        }
        return entries[index]
    }

    func logExercise(_ logged: LoggedExercise, for date: Date) {
        let dateISO = formatISO(date)
        let dayOfWeek = Calendar.current.component(.weekday, from: date) - 1

        var entry = getEntry(for: dateISO) ?? DayEntry(date: dateISO, dayOfWeek: dayOfWeek, exercises: [])

        if let index = entry.exercises.firstIndex(where: { $0.exerciseId == logged.exerciseId }) {
            entry.exercises[index] = logged
        } else {
            entry.exercises.append(logged)
        }

        saveEntry(entry)
    }

    func isExerciseCompleted(_ exerciseId: String, for date: Date) -> Bool {
        let dateISO = formatISO(date)
        guard let entry = getEntry(for: dateISO) else { return false }
        return entry.exercises.contains { $0.exerciseId == exerciseId }
    }

    func getLoggedExercise(_ exerciseId: String, for date: Date) -> LoggedExercise? {
        let dateISO = formatISO(date)
        guard let entry = getEntry(for: dateISO) else { return nil }
        return entry.exercises.first { $0.exerciseId == exerciseId }
    }

    func getCompletedCount(for date: Date) -> Int {
        let dateISO = formatISO(date)
        return getEntry(for: dateISO)?.exercises.count ?? 0
    }

    private func rebuildIndex() {
        entryIndexByDate.removeAll(keepingCapacity: true)
        for (index, entry) in entries.enumerated() {
            if entryIndexByDate[entry.date] == nil {
                entryIndexByDate[entry.date] = index
            }
        }
    }
}
