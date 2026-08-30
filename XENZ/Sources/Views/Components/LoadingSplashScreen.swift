import SwiftUI

struct LoadingSplashScreen: View {
    @Binding var isFinished: Bool

    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @State private var glowOpacity: Double = 0.3
    @State private var progress: CGFloat = 0.0

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 24) {
                Spacer()

                ZStack {
                    Circle()
                        .fill(Color(white: 0.12))
                        .frame(width: 120, height: 120)
                        .scaleEffect(1.15)
                        .opacity(glowOpacity)

                    Circle()
                        .strokeBorder(Color(white: 0.25), lineWidth: 1.5)
                        .frame(width: 108, height: 108)

                    if let iconPath = Bundle.main.path(forResource: "app_icon", ofType: "png"),
                       let uiImg = UIImage(contentsOfFile: iconPath) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())
                    } else if let uiImg = UIImage(named: "app_icon") {
                        Image(uiImage: uiImg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 96, height: 96)
                            .clipShape(Circle())
                    } else {
                        Text("X")
                            .font(.system(size: 42, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                    }
                }
                .scaleEffect(scale)

                VStack(spacing: 8) {
                    Text("XENZ")
                        .font(.system(size: 28, weight: .bold))
                        .tracking(8)
                        .foregroundStyle(.white)

                    Text("SECURE FINANCIAL CORE")
                        .font(.system(size: 9, weight: .semibold, design: .monospaced))
                        .tracking(4)
                        .foregroundStyle(Color(white: 0.45))
                }
                .opacity(opacity)

                Spacer()

                VStack(spacing: 12) {
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(white: 0.14))

                            Capsule()
                                .fill(Color.white)
                                .frame(width: proxy.size.width * progress)
                        }
                    }
                    .frame(width: 140, height: 4)

                    Text("INITIALIZING...")
                        .font(.system(size: 9, weight: .bold, design: .monospaced))
                        .tracking(2)
                        .foregroundStyle(Color(white: 0.35))
                }
                .opacity(opacity)
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.65, dampingFraction: 0.75)) {
                scale = 1.0
                opacity = 1.0
            }
            withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                glowOpacity = 0.75
            }
            withAnimation(.easeInOut(duration: 1.1)) {
                progress = 1.0
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.3) {
                withAnimation(.easeInOut(duration: 0.35)) {
                    isFinished = true
                }
            }
        }
    }
}
