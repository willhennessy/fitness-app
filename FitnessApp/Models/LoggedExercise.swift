import Foundation

struct LoggedExercise: Codable {
    let exerciseId: String
    // Strength fields
    let weightUsed: Int
    let setsCompleted: Int
    let repsCompleted: Int
    // Run fields
    let distanceMiles: Double?
    let timeMinutes: Int?
    let timestamp: Date
}
