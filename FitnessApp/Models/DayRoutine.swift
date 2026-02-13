import Foundation

struct DayRoutine: Identifiable, Codable {
    let dayOfWeek: Int
    let name: String
    let exercises: [Exercise]

    var id: Int { dayOfWeek }
    var isRestDay: Bool { exercises.isEmpty }
}
