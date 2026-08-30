import SwiftUI

struct DepositMoneySheet: View {
    @ObservedObject var store: BankingStore
    @Environment(\.dismiss) private var dismiss

    @State private var amountText: String = ""
    @State private var selectedMethod: String = "Apple Pay"
    @State private var isProcessing = false

    private let depositPresets: [Double] = [20.0, 50.0, 100.0, 250.0]
    private let methods = ["Apple Pay", "Credit Card", "Instant SEPA", "PayPal"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        amountSection

                        presetsRow

                        methodsSection

                        depositButton
                    }
                    .padding(20)
                }
            }
            .navigationTitle("Deposit Funds")
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

    private var amountSection: some View {
        VStack(spacing: 6) {
            Text("AMOUNT TO TOP UP")
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
        }
        .padding(.vertical, 10)
    }

    private var presetsRow: some View {
        HStack(spacing: 10) {
            ForEach(depositPresets, id: \.self) { val in
                Button {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    amountText = String(format: "%.2f", val)
                } label: {
                    Text("+€\(Int(val))")
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
        }
    }

    private var methodsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("PAYMENT METHOD")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            VStack(spacing: 8) {
                ForEach(methods, id: \.self) { method in
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        selectedMethod = method
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: methodIcon(for: method))
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                                .frame(width: 28)

                            Text(method)
                                .font(.system(size: 15, weight: .medium))
                                .foregroundStyle(.white)

                            Spacer()

                            if selectedMethod == method {
                                Image(systemName: "checkmark.circle.fill")
                                    .font(.system(size: 18))
                                    .foregroundStyle(.white)
                            } else {
                                Circle()
                                    .strokeBorder(Color(white: 0.25), lineWidth: 1.5)
                                    .frame(width: 18, height: 18)
                            }
                        }
                        .padding(14)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color(white: selectedMethod == method ? 0.12 : 0.07))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                                        .strokeBorder(selectedMethod == method ? Color.white.opacity(0.3) : Color(white: 0.14), lineWidth: 1)
                                )
                        )
                    }
                }
            }
        }
    }

    private func methodIcon(for method: String) -> String {
        switch method {
        case "Apple Pay":    return "applelogo"
        case "Credit Card":  return "creditcard.fill"
        case "Instant SEPA": return "bolt.fill"
        case "PayPal":       return "p.circle.fill"
        default:             return "banknote.fill"
        }
    }

    private var depositButton: some View {
        let clean = amountText.replacingOccurrences(of: ",", with: ".")
        let val = Double(clean) ?? 0.0
        let canDeposit = val > 0

        return Button {
            isProcessing = true
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                store.depositMoney(amount: val, source: selectedMethod)
                isProcessing = false
                dismiss()
            }
        } label: {
            HStack(spacing: 8) {
                if isProcessing {
                    ProgressView().tint(.black)
                } else {
                    Text("Top Up €\(String(format: "%.2f", val))")
                        .font(.system(size: 16, weight: .bold))
                }
            }
            .foregroundStyle(canDeposit ? Color.black : Color(white: 0.4))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(canDeposit ? Color.white : Color(white: 0.15))
            )
        }
        .disabled(!canDeposit || isProcessing)
    }
}
