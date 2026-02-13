import Foundation

struct DayEntry: Codable {
    let date: String
    let dayOfWeek: Int
    var exercises: [LoggedExercise]
}
