import SwiftUI

struct TransactionDetailSheet: View {
    let transaction: Transaction
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        headerSection

                        receiptCard

                        actionButtons
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Transaction Receipt")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color(white: 0.12))
                    .frame(width: 72, height: 72)
                    .overlay(Circle().strokeBorder(Color(white: 0.2), lineWidth: 1))

                Image(systemName: transaction.iconName)
                    .font(.system(size: 28))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 4) {
                Text(transaction.title)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundStyle(.white)

                Text(transaction.formattedAmount)
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(transaction.type == .income ? Color(red: 0.35, green: 0.9, blue: 0.55) : Color.white)
            }

            HStack(spacing: 6) {
                Circle()
                    .fill(Color(red: 0.35, green: 0.9, blue: 0.55))
                    .frame(width: 8, height: 8)
                Text("COMPLETED • SEPA INSTANT")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(white: 0.6))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color(white: 0.10)))
        }
        .padding(.vertical, 10)
    }

    private var receiptCard: some View {
        VStack(spacing: 14) {
            row(title: "TRANSACTION ID", value: transaction.id.uuidString.prefix(16) + "...", isMonospace: true)
            Divider().background(Color(white: 0.16))
            row(title: "DATE & TIME", value: transaction.formattedDateString)
            Divider().background(Color(white: 0.16))
            row(title: "CATEGORY", value: transaction.category.rawValue)
            Divider().background(Color(white: 0.16))
            if let iban = transaction.recipientIBAN {
                row(title: "IBAN", value: iban, isMonospace: true)
                Divider().background(Color(white: 0.16))
            }
            if let note = transaction.note {
                row(title: "REFERENCE", value: note)
                Divider().background(Color(white: 0.16))
            }
            row(title: "STATUS", value: "Settled (Immediate)")
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(white: 0.08))
                .overlay(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .strokeBorder(Color(white: 0.14), lineWidth: 1)
                )
        )
    }

    private func row(title: String, value: String, isMonospace: Bool = false) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.45))
                .tracking(1.5)

            Spacer()

            Text(value)
                .font(isMonospace ? .system(size: 13, weight: .medium, design: .monospaced) : .system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
    }

    private var actionButtons: some View {
        Button {
            let receipt = "XENZ TRANSACTION RECEIPT\nTitle: \(transaction.title)\nAmount: \(transaction.formattedAmount)\nDate: \(transaction.formattedDateString)\nCategory: \(transaction.category.rawValue)\nID: \(transaction.id)"
            let av = UIActivityViewController(activityItems: [receipt], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(av, animated: true)
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                Text("Export PDF Receipt")
                    .font(.system(size: 15, weight: .bold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color(white: 0.16))
            )
        }
    }
}
