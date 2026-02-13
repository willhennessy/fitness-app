import Foundation

struct LoggedExercise: Codable {
    let exerciseId: String
    let weightUsed: Int
    let setsCompleted: Int
    let repsCompleted: Int
    let timestamp: Date
}
