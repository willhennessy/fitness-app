import SwiftUI

struct SplashScreen: View {
    @State private var opacity: Double = 0

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            Text("Push your edge")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.appPrimary)
                .opacity(opacity)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.25)) {
                opacity = 1
            }
        }
    }
}

#Preview {
    SplashScreen()
}
