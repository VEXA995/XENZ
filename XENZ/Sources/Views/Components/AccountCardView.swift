import SwiftUI

struct AccountCardView: View {
    let account: BankAccount
    let onTap: () -> Void

    var body: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            onTap()
        }) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(white: 0.14))
                        .frame(width: 44, height: 44)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color(white: 0.20), lineWidth: 1)
                        )

                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 18, weight: .regular))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text(account.name)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.white)

                    Text(account.iban)
                        .font(.system(size: 12, weight: .regular, design: .monospaced))
                        .foregroundStyle(Color(white: 0.50))
                }

                Spacer()

                HStack(spacing: 6) {
                    Text(account.formattedBalance)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Color(white: 0.35))
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(white: 0.08))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .strokeBorder(Color(white: 0.14), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}
