import SwiftUI

@main
struct FitnessApp: App {
    @State private var showSplash = true
    @State private var splashOpacity: Double = 1
    @StateObject private var storage = StorageManager.shared

    var body: some Scene {
        WindowGroup {
            ZStack {
                DayView()
                    .environmentObject(storage)

                if showSplash {
                    SplashScreen()
                        .opacity(splashOpacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.7) {
                                withAnimation(.easeOut(duration: 0.3)) {
                                    splashOpacity = 0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    showSplash = false
                                }
                            }
                        }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}
