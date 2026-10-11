// Run: swift scripts/validate-exercise-images.swift [path/to/Routine.swift]
// Uses Apple's URLSession and ImageIO, including a real image decode.
import Foundation
import ImageIO

let source = try String(contentsOfFile: CommandLine.arguments.dropFirst().first ?? "FitnessApp/Data/Routine.swift", encoding: .utf8)
let pattern = try NSRegularExpression(pattern: "https://[^\\\"]+")
let urls = Set(pattern.matches(in: source, range: NSRange(source.startIndex..., in: source)).compactMap {
    Range($0.range, in: source).map { String(source[$0]) }
}).sorted()
var failures = 0
for raw in urls {
    do {
        var request = URLRequest(url: URL(string: raw)!)
        request.timeoutInterval = 20
        request.cachePolicy = .reloadIgnoringLocalCacheData
        let (data, response) = try await URLSession.shared.data(for: request)
        let status = (response as? HTTPURLResponse)?.statusCode ?? 0
        guard status == 200, let image = CGImageSourceCreateWithData(data as CFData, nil),
              CGImageSourceCreateImageAtIndex(image, 0, nil) != nil else {
            failures += 1
            print("FAIL HTTP \(status): \(raw)")
            continue
        }
        print("PASS: \(raw)")
    } catch {
        failures += 1
        print("FAIL \(error.localizedDescription): \(raw)")
    }
}
print("\(urls.count - failures)/\(urls.count) images decoded successfully")
exit(failures == 0 ? 0 : 1)
