import SwiftUI

struct CardsScreen: View {
    @ObservedObject var store: BankingStore
    @State private var selectedCardIndex = 0
    @State private var showNewCardSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        cardCarousel

                        if store.cards.indices.contains(selectedCardIndex) {
                            let card = store.cards[selectedCardIndex]
                            controlsSection(card: card)
                            limitsSection(card: card)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    .padding(.bottom, 100)
                }
            }
            .navigationTitle("Cards")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        showNewCardSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .sheet(isPresented: $showNewCardSheet) {
                newCardModal
            }
        }
    }

    private var cardCarousel: some View {
        VStack(spacing: 12) {
            TabView(selection: $selectedCardIndex) {
                ForEach(Array(store.cards.enumerated()), id: \.element.id) { idx, card in
                    CreditCardView(card: card) {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                    .tag(idx)
                    .padding(.horizontal, 4)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .frame(height: 235)

            Text("Tap card to flip and reveal security details (CVV)")
                .font(.system(size: 11, weight: .regular))
                .foregroundStyle(Color(white: 0.45))
        }
    }

    private func controlsSection(card: BankCard) -> some View {
        VStack(spacing: 14) {
            HStack {
                Text("CARD CONTROLS")
                    .font(.system(size: 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(Color(white: 0.5))
                    .tracking(1.5)
                Spacer()
            }

            VStack(spacing: 10) {
                controlRow(
                    title: "Freeze Card",
                    subtitle: card.isFrozen ? "Card is temporarily blocked" : "Lock transactions instantly",
                    icon: "snowflake",
                    isOn: card.isFrozen
                ) {
                    store.toggleCardFreeze(cardID: card.id)
                }

                Divider().background(Color(white: 0.14))

                controlRow(
                    title: "Online Payments",
                    subtitle: "Allow internet & in-app purchases",
                    icon: "cart.fill",
                    isOn: card.isOnlinePaymentsEnabled
                ) {
                    if let idx = store.cards.firstIndex(where: { $0.id == card.id }) {
                        store.cards[idx].isOnlinePaymentsEnabled.toggle()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }

                Divider().background(Color(white: 0.14))

                controlRow(
                    title: "Contactless / Apple Pay",
                    subtitle: "NFC and terminal payments",
                    icon: "wave.3.forward",
                    isOn: card.isContactlessEnabled
                ) {
                    if let idx = store.cards.firstIndex(where: { $0.id == card.id }) {
                        store.cards[idx].isContactlessEnabled.toggle()
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    }
                }
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
    }

    private func controlRow(title: String, subtitle: String, icon: String, isOn: Bool, onToggle: @escaping () -> Void) -> some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(white: 0.12))
                    .frame(width: 38, height: 38)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Text(subtitle)
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(Color(white: 0.45))
            }

            Spacer()

            Toggle("", isOn: Binding(
                get: { isOn },
                set: { _ in onToggle() }
            ))
            .labelsHidden()
            .tint(Color.white)
        }
    }

    private func limitsSection(card: BankCard) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("SPENDING LIMITS")
                .font(.system(size: 10, weight: .bold, design: .monospaced))
                .foregroundStyle(Color(white: 0.5))
                .tracking(1.5)

            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Monthly Limit")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.white)
                    Spacer()
                    Text("€\(String(format: "%.0f", card.currentSpent)) / €\(String(format: "%.0f", card.monthlyLimit))")
                        .font(.system(size: 13, weight: .medium, design: .monospaced))
                        .foregroundStyle(Color(white: 0.7))
                }

                GeometryReader { proxy in
                    let pct = min(1.0, card.currentSpent / max(1.0, card.monthlyLimit))
                    ZStack(alignment: .leading) {
                        Capsule().fill(Color(white: 0.16))
                        Capsule().fill(Color.white)
                            .frame(width: proxy.size.width * CGFloat(pct))
                    }
                }
                .frame(height: 8)
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
    }

    private var newCardModal: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("CREATE VIRTUAL CARD")
                        .font(.system(size: 11, weight: .bold, design: .monospaced))
                        .foregroundStyle(Color(white: 0.5))
                        .tracking(2)
                        .padding(.top, 20)

                    Text("Instant Virtual Cyber Card")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Generate a disposable virtual card with automated CVV rotation for secure subscriptions and gaming.")
                        .font(.system(size: 14))
                        .foregroundStyle(Color(white: 0.6))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 30)

                    Spacer()

                    Button {
                        let newCard = BankCard(
                            cardholderName: store.userProfile.name,
                            cardNumber: "4920 \(Int.random(in: 1000...9999)) \(Int.random(in: 1000...9999)) \(Int.random(in: 1000...9999))",
                            expiryDate: "12/29",
                            cvv: "\(Int.random(in: 100...999))",
                            cardType: "Virtual Cyber Card",
                            theme: .cyberNeon,
                            monthlyLimit: 750.0,
                            currentSpent: 0.0
                        )
                        store.cards.append(newCard)
                        showNewCardSheet = false
                    } label: {
                        Text("Create Instant Card")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .fill(Color.white)
                            )
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { showNewCardSheet = false }
                        .foregroundStyle(.white)
                }
            }
        }
    }
}
