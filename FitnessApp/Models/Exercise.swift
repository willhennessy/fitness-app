import Foundation

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let sets: Int
    let reps: String
    let images: [String]
    let cues: [String]
    let why: String
}
