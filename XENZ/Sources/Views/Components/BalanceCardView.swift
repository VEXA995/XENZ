import SwiftUI

struct BalanceCardView: View {
    let balanceText: String
    let onSend: () -> Void
    let onReceive: () -> Void
    let onDeposit: () -> Void
    let onMore: () -> Void
    let onDetails: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Total Balance")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(Color(white: 0.55))

                    Text(balanceText)
                        .font(.system(size: 38, weight: .bold))
                        .foregroundStyle(.white)
                        .tracking(-0.5)

                    HStack(spacing: 4) {
                        Text("+ €14.20 (12.4%)")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(.white)

                        Text("this month")
                            .font(.system(size: 13, weight: .regular))
                            .foregroundStyle(Color(white: 0.50))
                    }
                }

                Spacer()

                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    onDetails()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.white)
                            .frame(width: 48, height: 48)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.black)
                    }
                }
                .buttonStyle(.plain)
            }

            HStack(spacing: 0) {
                QuickActionButton(title: "Send", iconName: "arrow.up.right", action: onSend)
                QuickActionButton(title: "Receive", iconName: "arrow.down.left", action: onReceive)
                QuickActionButton(title: "Deposit", iconName: "plus", action: onDeposit)
                QuickActionButton(title: "More", iconName: "ellipsis", action: onMore)
            }
            .padding(.top, 6)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 22)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(Color(white: 0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 24, style: .continuous)
                        .strokeBorder(Color(white: 0.14), lineWidth: 1)
                )
        )
    }
}
