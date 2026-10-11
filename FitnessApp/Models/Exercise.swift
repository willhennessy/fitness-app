import Foundation

struct Exercise: Identifiable, Codable {
    let id: String
    let name: String
    let sets: Int
    let reps: String
    let images: [String]
    let cues: [String]
    let why: String
    var isRun: Bool = false
    var isTimedOnly: Bool = false

    /// Returns the catalog exercise with only its routine-specific prescription changed.
    /// Identity and presentation metadata stay canonical across routine revisions.
    func prescribed(sets: Int, reps: String) -> Exercise {
        Exercise(
            id: id,
            name: name,
            sets: sets,
            reps: reps,
            images: images,
            cues: cues,
            why: why,
            isRun: isRun,
            isTimedOnly: isTimedOnly
        )
    }
}
