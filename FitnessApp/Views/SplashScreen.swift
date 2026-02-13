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
            withAnimation(.easeIn(duration: 0.3)) {
                opacity = 1
            }
        }
    }
}

#Preview {
    SplashScreen()
}
