import SwiftUI

struct SendMoneySheet: View {
    @ObservedObject var store: BankingStore
    @Environment(\.dismiss) private var dismiss

    @State private var recipient: String = ""
    @State private var iban: String = ""
    @State private var amountText: String = ""
    @State private var note: String = ""
    @State private var selectedCategory: TransactionCategory = .transfer
    @State private var isAuthorizing: Bool = false
    @State private var isSuccess: Bool = false

    private let presets: [Double] = [5.0, 10.0, 20.0, 50.0]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        amountHeader

                        quickPresets

                        VStack(spacing: 16) {
                            inputCard(title: "RECIPIENT NAME", icon: "person.fill") {
                                TextField("e.g. Alex, Discord, Roblox Store", text: $recipient)
                                    .foregroundStyle(.white)
                            }

                            inputCard(title: "IBAN", icon: "creditcard.fill") {
                                TextField("e.g. DE89 3704 0044 0532 0130 00", text: $iban)
                                    .textInputAutocapitalization(.characters)
                                    .autocorrectionDisabled(true)
                                    .foregroundStyle(.white)
                                    .font(.system(.body, design: .monospaced))
                            }

                            inputCard(title: "NOTE / REFERENCE", icon: "text.bubble.fill") {
                                TextField("e.g. Discord Nitro Boost, Roblox Gift", text: $note)
                                    .foregroundStyle(.white)
                            }

                            categorySelector
                        }

                        sendButton
                            .padding(.top, 10)
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Send Money")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .foregroundStyle(Color(white: 0.6))
                }
            }
        }
    }

    private var amountHeader: some View {
        VStack(spacing: 6) {
            Text("ENTER AMOUNT")
                .font(.system(size: 11, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.45))
                .tracking(2)

            HStack(spacing: 4) {
                Text("€")
                    .font(.system(size: 38, weight: .bold))
                    .foregroundStyle(.white)

                TextField("0.00", text: $amountText)
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .keyboardType(.decimalPad)
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .frame(minWidth: 120)
            }

            Text("Available Balance: \(store.account.formattedBalance)")
                .font(.system(size: 13, weight: .regular))
                .foregroundStyle(Color(white: 0.5))
        }
        .padding(.vertical, 10)
    }

    private var quickPresets: some View {
        HStack(spacing: 10) {
            ForEach(presets, id: \.self) { val in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    amountText = String(format: "%.2f", val)
                } label: {
                    Text("€\(Int(val))")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .fill(Color(white: 0.12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                                        .strokeBorder(Color(white: 0.20), lineWidth: 1)
                                )
                        )
                }
            }

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                amountText = String(format: "%.2f", store.account.balance)
            } label: {
                Text("MAX")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color(white: 0.20))
                    )
            }
        }
    }

    private func inputCard<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 11))
                    .foregroundStyle(Color(white: 0.5))
                Text(title)
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(white: 0.5))
                    .tracking(1.5)
            }

            content()
                .padding(14)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(Color(white: 0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .strokeBorder(Color(white: 0.16), lineWidth: 1)
                        )
                )
        }
    }

    private var categorySelector: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("CATEGORY")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(TransactionCategory.allCases, id: \.self) { cat in
                        Button {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            selectedCategory = cat
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: cat.defaultIcon)
                                    .font(.system(size: 12))
                                Text(cat.rawValue)
                                    .font(.system(size: 12, weight: .medium))
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .foregroundStyle(selectedCategory == cat ? Color.black : Color.white)
                            .background(
                                Capsule()
                                    .fill(selectedCategory == cat ? Color.white : Color(white: 0.12))
                            )
                        }
                    }
                }
            }
        }
    }

    private var sendButton: some View {
        let cleanAmount = amountText.replacingOccurrences(of: ",", with: ".")
        let amountVal = Double(cleanAmount) ?? 0.0
        let canSend = amountVal > 0 && amountVal <= store.account.balance && !recipient.isEmpty

        return Button {
            authorizeAndSend(amount: amountVal)
        } label: {
            HStack(spacing: 8) {
                if isAuthorizing {
                    ProgressView()
                        .tint(.black)
                } else {
                    Image(systemName: "faceid")
                        .font(.system(size: 18))
                    Text("Send €\(String(format: "%.2f", amountVal))")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .foregroundStyle(canSend ? Color.black : Color(white: 0.4))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(canSend ? Color.white : Color(white: 0.15))
            )
        }
        .disabled(!canSend || isAuthorizing)
    }

    private func authorizeAndSend(amount: Double) {
        isAuthorizing = true
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            let success = store.sendMoney(
                recipient: recipient,
                iban: iban.isEmpty ? "DE89 3704 0044 0532 0130 00" : iban,
                amount: amount,
                note: note.isEmpty ? "SEPA Transfer" : note,
                category: selectedCategory
            )
            isAuthorizing = false
            if success {
                dismiss()
            }
        }
    }
}
