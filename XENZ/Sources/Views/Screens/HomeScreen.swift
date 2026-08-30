import SwiftUI

struct HomeScreen: View {
    @ObservedObject var store: BankingStore

    @State private var showSendSheet = false
    @State private var showReceiveSheet = false
    @State private var showDepositSheet = false
    @State private var showSettings = false
    @State private var showAllTransactions = false
    @State private var selectedTransaction: Transaction? = nil

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    topBar

                    BalanceCardView(
                        balanceText: store.account.formattedBalance,
                        onSend: { showSendSheet = true },
                        onReceive: { showReceiveSheet = true },
                        onDeposit: { showDepositSheet = true },
                        onMore: { showSettings = true },
                        onDetails: { showAllTransactions = true }
                    )

                    accountsSection

                    transactionsSection
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 110)
            }

            if let notif = store.activeNotification {
                VStack {
                    InAppNotificationBanner(notification: notif) {
                        store.activeNotification = nil
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .padding(.top, 10)
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $showSendSheet) {
            SendMoneySheet(store: store)
        }
        .sheet(isPresented: $showReceiveSheet) {
            ReceiveMoneySheet(store: store)
        }
        .sheet(isPresented: $showDepositSheet) {
            DepositMoneySheet(store: store)
        }
        .sheet(isPresented: $showSettings) {
            SettingsScreen(store: store)
        }
        .sheet(item: $selectedTransaction) { tx in
            TransactionDetailSheet(transaction: tx)
        }
    }

    private var topBar: some View {
        HStack(alignment: .center) {
            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showSettings = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(white: 0.12))
                        .frame(width: 44, height: 44)
                        .overlay(Circle().strokeBorder(Color(white: 0.2), lineWidth: 1))

                    if let iconPath = Bundle.main.path(forResource: "app_icon", ofType: "png"),
                       let uiImg = UIImage(contentsOfFile: iconPath) {
                        Image(uiImage: uiImg)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "person.fill")
                            .font(.system(size: 17, weight: .regular))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)

            Spacer()

            VStack(spacing: 2) {
                Text("Xenz")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundStyle(.white)
                    .tracking(-0.5)

                Text("Welcome Back, \(store.userProfile.name)")
                    .font(.system(size: 11, weight: .medium, design: .monospaced))
                    .foregroundStyle(Color(white: 0.45))
            }

            Spacer()

            Button {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                showReceiveSheet = true
            } label: {
                ZStack {
                    Circle()
                        .fill(Color(white: 0.12))
                        .frame(width: 44, height: 44)
                        .overlay(Circle().strokeBorder(Color(white: 0.2), lineWidth: 1))

                    Image(systemName: "bell.fill")
                        .font(.system(size: 16, weight: .regular))
                        .foregroundStyle(.white)

                    Circle()
                        .fill(Color(red: 0.35, green: 0.9, blue: 0.55))
                        .frame(width: 8, height: 8)
                        .offset(x: 10, y: -10)
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }

    private var accountsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Accounts")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Button("View All") {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    showSettings = true
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(white: 0.55))
            }

            AccountCardView(account: store.account) {
                showReceiveSheet = true
            }
        }
    }

    private var transactionsSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Transactions")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Spacer()

                Button(showAllTransactions ? "Show Less" : "View All") {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        showAllTransactions.toggle()
                    }
                }
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(Color(white: 0.55))
            }

            let displayList = showAllTransactions ? store.transactions : Array(store.transactions.prefix(6))

            VStack(spacing: 0) {
                ForEach(Array(displayList.enumerated()), id: \.element.id) { idx, tx in
                    TransactionRowView(transaction: tx) {
                        selectedTransaction = tx
                    }

                    if idx < displayList.count - 1 {
                        Divider()
                            .background(Color(white: 0.12))
                            .padding(.leading, 74)
                    }
                }
            }
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
}
