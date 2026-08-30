import SwiftUI

struct LoadingSplashScreen: View {
    @Binding var isFinished: Bool

    @State private var scale: CGFloat = 0.92
    @State private var opacity: Double = 0.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(Color(white: 0.08))
                        .frame(width: 88, height: 88)
                        .overlay(Circle().strokeBorder(Color(white: 0.18), lineWidth: 1))

                    if let iconPath = Bundle.main.path(forResource: "app_icon", ofType: "png"),
                       let uiImg = UIImage(contentsOfFile: iconPath) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else if let uiImg = UIImage(named: "app_icon") {
                        Image(uiImage: uiImg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                    } else {
                        Text("X")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
                .scaleEffect(scale)

                VStack(spacing: 4) {
                    Text("XENZ")
                        .font(.system(size: 22, weight: .bold))
                        .tracking(6)
                        .foregroundStyle(.white)

                    Text("FINANCIAL OS")
                        .font(.system(size: 8, weight: .semibold, design: .monospaced))
                        .tracking(3)
                        .foregroundStyle(Color(white: 0.40))
                }
                .opacity(opacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.45, dampingFraction: 0.8)) {
                scale = 1.0
                opacity = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isFinished = true
                }
            }
        }
    }
}
