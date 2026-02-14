import SwiftUI

struct Celebration: View {
    let onDismiss: () -> Void
    @State private var iconScale: CGFloat = 0.5

    var body: some View {
        ZStack {
            Color.appBackground
                .ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                Image(systemName: "trophy")
                    .font(.system(size: 80))
                    .foregroundColor(.appPrimary)
                    .scaleEffect(iconScale)
                    .onAppear {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                            iconScale = 1.2
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.spring(response: 0.2, dampingFraction: 0.7)) {
                                iconScale = 1.0
                            }
                        }
                    }

                Text("Great work!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.appText)

                Text("You pushed your edge")
                    .font(.system(size: 17))
                    .foregroundColor(.appTextMuted)

                Spacer()

                Button {
                    onDismiss()
                } label: {
                    Text("Carpe diem")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.appBackground)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 32)
            }
        }
    }
}

#Preview {
    Celebration(onDismiss: {})
}
