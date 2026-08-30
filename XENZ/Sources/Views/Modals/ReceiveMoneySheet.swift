import SwiftUI

struct ReceiveMoneySheet: View {
    @ObservedObject var store: BankingStore
    @Environment(\.dismiss) private var dismiss
    @State private var showCopiedBadge = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        qrCodeSection

                        detailsCard

                        shareButton
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Receive Money")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                    .foregroundStyle(.white)
                }
            }
        }
    }

    private var qrCodeSection: some View {
        VStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(.white)
                    .frame(width: 200, height: 200)

                VStack(spacing: 8) {
                    Image(systemName: "qrcode")
                        .font(.system(size: 140))
                        .foregroundStyle(.black)
                }
            }

            VStack(spacing: 4) {
                Text("SCAN TO PAY ME")
                    .font(.system(size: 11, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(white: 0.5))
                    .tracking(2)

                Text(store.userProfile.tag)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
            }
        }
        .padding(.vertical, 10)
    }

    private var detailsCard: some View {
        VStack(spacing: 14) {
            detailRow(title: "ACCOUNT HOLDER", value: store.userProfile.name)
            Divider().background(Color(white: 0.16))
            detailRow(title: "IBAN", value: store.account.iban, isCopyable: true)
            Divider().background(Color(white: 0.16))
            detailRow(title: "BIC / SWIFT", value: store.account.bic, isCopyable: true)
            Divider().background(Color(white: 0.16))
            detailRow(title: "BANK NAME", value: "Xenz Neo Bank AG")
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

    private func detailRow(title: String, value: String, isCopyable: Bool = false) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 9, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(white: 0.45))
                    .tracking(1.5)

                Text(value)
                    .font(.system(size: 14, weight: .semibold, design: .monospaced))
                    .foregroundStyle(.white)
            }

            Spacer()

            if isCopyable {
                Button {
                    UIPasteboard.general.string = value
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    withAnimation { showCopiedBadge = true }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        withAnimation { showCopiedBadge = false }
                    }
                } label: {
                    Image(systemName: showCopiedBadge ? "checkmark" : "doc.on.doc")
                        .font(.system(size: 14))
                        .foregroundStyle(showCopiedBadge ? Color(red: 0.35, green: 0.9, blue: 0.55) : Color(white: 0.6))
                        .padding(8)
                        .background(Circle().fill(Color(white: 0.15)))
                }
            }
        }
    }

    private var shareButton: some View {
        Button {
            let shareText = "My Xenz Bank Details:\nName: \(store.userProfile.name)\nIBAN: \(store.account.iban)\nBIC: \(store.account.bic)"
            let av = UIActivityViewController(activityItems: [shareText], applicationActivities: nil)
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let rootVC = windowScene.windows.first?.rootViewController {
                rootVC.present(av, animated: true)
            }
        } label: {
            HStack(spacing: 8) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16, weight: .semibold))
                Text("Share Bank Details")
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
