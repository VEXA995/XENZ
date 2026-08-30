import SwiftUI

struct TransactionRowView: View {
    let transaction: Transaction
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            onTap()
        }) {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(white: 0.12))
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color(white: 0.18), lineWidth: 1)
                        )

                    Image(systemName: transaction.iconName)
                        .font(.system(size: 17, weight: .regular))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text(transaction.title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(transaction.formattedDateString)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color(white: 0.45))
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 3) {
                    Text(transaction.formattedAmount)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(transaction.type == .income ? Color(red: 0.35, green: 0.85, blue: 0.55) : Color.white)

                    Text(transaction.subtitle)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(Color(white: 0.45))
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color(white: 0.28))
                    .padding(.leading, 2)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
