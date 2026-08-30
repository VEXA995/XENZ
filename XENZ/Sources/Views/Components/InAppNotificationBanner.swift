import SwiftUI

struct InAppNotificationBanner: View {
    let notification: InAppNotification
    let onDismiss: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(notification.isSuccess ? Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.2) : Color.red.opacity(0.2))
                    .frame(width: 38, height: 38)

                Image(systemName: notification.iconName)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(notification.isSuccess ? Color(red: 0.35, green: 0.9, blue: 0.55) : Color.red)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(notification.title)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(.white)

                Text(notification.message)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color(white: 0.75))
                    .lineLimit(2)
            }

            Spacer()

            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                onDismiss()
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(Color(white: 0.4))
                    .padding(6)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Capsule()
                .fill(Color(white: 0.12))
                .overlay(
                    Capsule()
                        .strokeBorder(Color(white: 0.24), lineWidth: 1)
                )
                .shadow(color: Color.black.opacity(0.7), radius: 16, x: 0, y: 8)
        )
        .padding(.horizontal, 16)
    }
}
