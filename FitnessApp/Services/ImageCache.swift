import UIKit

class ImageCache {
    static let shared = ImageCache()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let cacheDirectory: URL

    private init() {
        let caches = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        cacheDirectory = caches.appendingPathComponent("ImageCache")
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
        memoryCache.countLimit = 200
    }

    func image(for url: URL) -> UIImage? {
        let key = url.absoluteString as NSString
        if let cached = memoryCache.object(forKey: key) {
            return cached
        }
        let fileURL = cacheDirectory.appendingPathComponent(stableKey(for: url))
        if let data = try? Data(contentsOf: fileURL), let image = UIImage(data: data) {
            memoryCache.setObject(image, forKey: key)
            return image
        }
        return nil
    }

    func store(_ image: UIImage, for url: URL) {
        let key = url.absoluteString as NSString
        memoryCache.setObject(image, forKey: key)
        let fileURL = cacheDirectory.appendingPathComponent(stableKey(for: url))

        guard let data = image.jpegData(compressionQuality: 1.0) else { return }

        Task(priority: .utility) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }

    func invalidateIfURLsChanged(_ urls: [String]) {
        let storageKey = "ImageCache.urlsHash"
        let hash = fnv1a(urls.joined())
        let stored = UserDefaults.standard.string(forKey: storageKey)
        if stored != hash {
            clearAll()
            UserDefaults.standard.set(hash, forKey: storageKey)
        }
    }

    private func clearAll() {
        memoryCache.removeAllObjects()
        try? FileManager.default.removeItem(at: cacheDirectory)
        try? FileManager.default.createDirectory(at: cacheDirectory, withIntermediateDirectories: true)
    }

    // FNV-1a hash — stable across launches, unlike Swift's hashValue
    private func stableKey(for url: URL) -> String {
        return "\(fnv1a(url.absoluteString)).jpg"
    }

    private func fnv1a(_ string: String) -> String {
        var hash: UInt64 = 14695981039346656037
        for byte in string.utf8 {
            hash ^= UInt64(byte)
            hash = hash &* 1099511628211
        }
        return "\(hash)"
    }
}
