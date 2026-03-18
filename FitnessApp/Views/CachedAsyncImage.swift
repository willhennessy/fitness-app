import SwiftUI

struct CachedAsyncImage<Content: View, Placeholder: View>: View {
    let url: URL?
    let content: (Image) -> Content
    let placeholder: () -> Placeholder

    @State private var image: UIImage? = nil

    var body: some View {
        Group {
            if let image {
                content(Image(uiImage: image))
            } else {
                placeholder()
            }
        }
        .task(id: url) {
            await load(for: url)
        }
    }

    private func load(for targetURL: URL?) async {
        guard let targetURL else {
            image = nil
            return
        }

        if let cached = ImageCache.shared.image(for: targetURL) {
            image = cached
            return
        }

        guard let (data, _) = try? await URLSession.shared.data(from: targetURL),
              let loaded = UIImage(data: data) else { return }

        ImageCache.shared.store(loaded, for: targetURL)
        guard url == targetURL else { return }
        image = loaded
    }
}
