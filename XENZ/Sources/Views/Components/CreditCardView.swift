import SwiftUI

struct CreditCardView: View {
    let card: BankCard
    let onFlip: () -> Void

    @State private var isFlipped = false
    @State private var showCopiedBadge = false

    var body: some View {
        ZStack {
            if !isFlipped {
                frontSide
            } else {
                backSide
            }
        }
        .frame(height: 205)
        .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .onTapGesture {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.75)) {
                isFlipped.toggle()
                onFlip()
            }
        }
    }

    private var frontSide: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: card.theme.gradientColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color(white: 0.22), lineWidth: 1)
                )

            if card.isFrozen {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.blue.opacity(0.15))
                    .overlay(
                        HStack(spacing: 8) {
                            Image(systemName: "snowflake")
                                .font(.system(size: 22))
                            Text("CARD FROZEN")
                                .font(.system(size: 13, weight: .bold, design: .monospaced))
                                .tracking(2)
                        }
                        .foregroundStyle(Color(red: 0.6, green: 0.85, blue: 1.0))
                    )
            }

            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text("Xenz")
                            .font(.system(size: 18, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)
                            .tracking(1)

                        Text(card.cardType)
                            .font(.system(size: 10, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color(white: 0.6))
                    }

                    Spacer()

                    Image(systemName: "wave.3.forward")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(Color(white: 0.5))
                }

                Spacer()

                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 6, style: .continuous)
                        .fill(Color(white: 0.25))
                        .frame(width: 38, height: 28)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6, style: .continuous)
                                .strokeBorder(Color(white: 0.4), lineWidth: 0.8)
                        )

                    Text(card.maskedNumber)
                        .font(.system(size: 17, weight: .medium, design: .monospaced))
                        .foregroundStyle(.white)
                        .tracking(1.5)
                }

                Spacer()

                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("CARDHOLDER")
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color(white: 0.45))
                        Text(card.cardholderName)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    VStack(alignment: .leading, spacing: 2) {
                        Text("EXPIRES")
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color(white: 0.45))
                        Text(card.expiryDate)
                            .font(.system(size: 13, weight: .semibold, design: .monospaced))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Image(systemName: "creditcard.and.123")
                        .font(.system(size: 18, weight: .light))
                        .foregroundStyle(Color(white: 0.7))
                }
            }
            .padding(20)
        }
    }

    private var backSide: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: card.theme.gradientColors.reversed(),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .strokeBorder(Color(white: 0.22), lineWidth: 1)
                )

            VStack(spacing: 14) {
                Rectangle()
                    .fill(Color.black)
                    .frame(height: 38)
                    .padding(.top, 14)

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("FULL CARD NUMBER")
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color(white: 0.45))

                        Text(card.cardNumber)
                            .font(.system(size: 14, weight: .medium, design: .monospaced))
                            .foregroundStyle(.white)
                    }

                    Spacer()

                    Button {
                        UIPasteboard.general.string = card.cardNumber
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        withAnimation { showCopiedBadge = true }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation { showCopiedBadge = false }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Image(systemName: showCopiedBadge ? "checkmark" : "doc.on.doc")
                                .font(.system(size: 11))
                            Text(showCopiedBadge ? "COPIED" : "COPY")
                                .font(.system(size: 10, weight: .bold, design: .monospaced))
                        }
                        .foregroundStyle(.white)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(Capsule().fill(Color(white: 0.25)))
                    }
                }
                .padding(.horizontal, 20)

                HStack {
                    Spacer()
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("SECURITY CODE")
                            .font(.system(size: 8, weight: .semibold, design: .monospaced))
                            .foregroundStyle(Color(white: 0.45))

                        HStack(spacing: 6) {
                            Text("CVV")
                                .font(.system(size: 10, weight: .regular, design: .monospaced))
                                .foregroundStyle(Color(white: 0.5))
                            Text(card.cvv)
                                .font(.system(size: 14, weight: .bold, design: .monospaced))
                                .foregroundStyle(.white)
                        }
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(RoundedRectangle(cornerRadius: 6).fill(Color(white: 0.18)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }
        }
        .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
    }
}
