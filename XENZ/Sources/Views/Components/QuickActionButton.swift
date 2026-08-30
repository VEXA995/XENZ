import SwiftUI

struct QuickActionButton: View {
    let title: String
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            action()
        }) {
            VStack(spacing: 8) {
                ZStack {
                    Circle()
                        .fill(Color(white: 0.12))
                        .frame(width: 56, height: 56)
                        .overlay(
                            Circle()
                                .strokeBorder(Color(white: 0.18), lineWidth: 1)
                        )

                    Image(systemName: iconName)
                        .font(.system(size: 18, weight: .medium))
                        .foregroundStyle(.white)
                }

                Text(title)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundStyle(Color(white: 0.85))
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
    }
}
