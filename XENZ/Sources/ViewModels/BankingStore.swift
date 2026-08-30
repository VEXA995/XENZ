import Foundation
import SwiftUI
import Combine

struct InAppNotification: Identifiable, Equatable {
    let id = UUID()
    var title: String
    var message: String
    var iconName: String
    var isSuccess: Bool
}

@MainActor
final class BankingStore: ObservableObject {

    @Published var account: BankAccount {
        didSet { saveAccount() }
    }
    @Published var transactions: [Transaction] = [] {
        didSet { saveTransactions() }
    }
    @Published var cards: [BankCard] = [] {
        didSet { saveCards() }
    }
    @Published var userProfile: UserProfile {
        didSet { saveProfile() }
    }
    @Published var activeNotification: InAppNotification? = nil

    private let accountKey      = "xenz.bankAccount"
    private let transactionsKey = "xenz.transactions"
    private let cardsKey        = "xenz.bankCards"
    private let profileKey      = "xenz.userProfile"

    init() {
        if let data = UserDefaults.standard.data(forKey: accountKey),
           let decoded = try? JSONDecoder().decode(BankAccount.self, from: data) {
            self.account = decoded
        } else {
            self.account = BankAccount(
                name: "Main Account",
                iban: "DE12 3456 7890 1234 5678 90",
                bic: "XENZDEFFXXX",
                balance: 82.87,
                currency: "€"
            )
        }

        if let data = UserDefaults.standard.data(forKey: profileKey),
           let decoded = try? JSONDecoder().decode(UserProfile.self, from: data) {
            self.userProfile = decoded
        } else {
            self.userProfile = UserProfile(name: "047", tag: "@047")
        }

        if let data = UserDefaults.standard.data(forKey: cardsKey),
           let decoded = try? JSONDecoder().decode([BankCard].self, from: data) {
            self.cards = decoded
        } else {
            self.cards = [
                BankCard(
                    cardholderName: "047",
                    cardNumber: "4729 8819 0470 4072",
                    expiryDate: "08/29",
                    cvv: "470",
                    cardType: "Black Metal Debit",
                    theme: .obsidianMetal,
                    isFrozen: false,
                    monthlyLimit: 1500.0,
                    currentSpent: 312.45
                ),
                BankCard(
                    cardholderName: "047",
                    cardNumber: "5210 9410 8820 1904",
                    expiryDate: "11/28",
                    cvv: "912",
                    cardType: "Virtual Cyber Card",
                    theme: .cyberNeon,
                    isFrozen: false,
                    monthlyLimit: 500.0,
                    currentSpent: 42.10
                ),
                BankCard(
                    cardholderName: "047",
                    cardNumber: "3782 8224 0047 9120",
                    expiryDate: "03/30",
                    cvv: "238",
                    cardType: "Titanium Platinum",
                    theme: .titaniumSilver,
                    isFrozen: false,
                    monthlyLimit: 3000.0,
                    currentSpent: 890.00
                )
            ]
        }

        if let data = UserDefaults.standard.data(forKey: transactionsKey),
           let decoded = try? JSONDecoder().decode([Transaction].self, from: data) {
            self.transactions = decoded
        } else {
            self.transactions = Self.seedTransactions()
        }
    }

    private static func seedTransactions() -> [Transaction] {
        let now = Date()
        let cal = Calendar.current

        let today1 = now.addingTimeInterval(-3600 * 2)
        let today2 = now.addingTimeInterval(-3600 * 4)
        let today3 = now.addingTimeInterval(-3600 * 6)
        let yesterday = cal.date(byAdding: .day, value: -1, to: now) ?? now
        let twoDaysAgo = cal.date(byAdding: .day, value: -2, to: now) ?? now
        let threeDaysAgo = cal.date(byAdding: .day, value: -3, to: now) ?? now
        let fourDaysAgo = cal.date(byAdding: .day, value: -4, to: now) ?? now
        let fiveDaysAgo = cal.date(byAdding: .day, value: -5, to: now) ?? now

        return [
            Transaction(
                title: "Discord Nitro",
                subtitle: "Monthly Subscription",
                amount: 9.99,
                date: today1,
                category: .subscriptions,
                type: .expense,
                recipientIBAN: "LU89 0123 4567 8901 2345 67",
                note: "Nitro Boost Subscription",
                iconName: "play.tv.fill"
            ),
            Transaction(
                title: "Roblox",
                subtitle: "Robux 80 pack",
                amount: 1.19,
                date: today2,
                category: .gaming,
                type: .expense,
                recipientIBAN: "US99 ROBL OX12 4019 4810 29",
                note: "Avatar Accessory Pack",
                iconName: "gamecontroller.fill"
            ),
            Transaction(
                title: "Roblox",
                subtitle: "Robux 80 pack",
                amount: 1.19,
                date: today3,
                category: .gaming,
                type: .expense,
                recipientIBAN: "US99 ROBL OX12 4019 4810 29",
                note: "Gamepass Upgrade",
                iconName: "gamecontroller.fill"
            ),
            Transaction(
                title: "Eneba",
                subtitle: "Gaming Keys & Wallet",
                amount: 14.99,
                date: yesterday,
                category: .gaming,
                type: .expense,
                recipientIBAN: "LT44 7044 0600 0123 4567 89",
                note: "Steam Digital Gift Card",
                iconName: "gamecontroller.fill"
            ),
            Transaction(
                title: "Amazon",
                subtitle: "Shopping Order",
                amount: 24.50,
                date: twoDaysAgo,
                category: .shopping,
                type: .expense,
                recipientIBAN: "DE44 5001 0517 5409 3210 00",
                note: "Tech Accessories",
                iconName: "bag.fill"
            ),
            Transaction(
                title: "Starbucks",
                subtitle: "Food & Drinks",
                amount: 5.45,
                date: threeDaysAgo,
                category: .foodAndDrinks,
                type: .expense,
                note: "Iced Caramel Macchiato",
                iconName: "cup.and.saucer.fill"
            ),
            Transaction(
                title: "Uber",
                subtitle: "Transport Ride",
                amount: 18.75,
                date: fourDaysAgo,
                category: .transport,
                type: .expense,
                note: "City Transfer",
                iconName: "tram.fill"
            ),
            Transaction(
                title: "Salary / Transfer",
                subtitle: "Incoming Deposit",
                amount: 145.00,
                date: fiveDaysAgo,
                category: .income,
                type: .income,
                recipientIBAN: "DE89 3704 0044 0532 0130 00",
                note: "Monthly Pocket Allowance",
                iconName: "briefcase.fill"
            )
        ]
    }

    func sendMoney(
        recipient: String,
        iban: String,
        amount: Double,
        note: String,
        category: TransactionCategory
    ) -> Bool {
        guard amount > 0 else { return false }
        guard account.balance >= amount else {
            showNotification(title: "Insufficient Funds", message: "Balance is too low for this transfer.", isSuccess: false)
            return false
        }

        account.balance -= amount
        let newTx = Transaction(
            title: recipient.isEmpty ? "Direct Transfer" : recipient,
            subtitle: note.isEmpty ? "SEPA Instant Transfer" : note,
            amount: amount,
            date: Date(),
            category: category,
            type: .expense,
            recipientIBAN: iban,
            note: note,
            iconName: category.defaultIcon
        )
        transactions.insert(newTx, at: 0)

        UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        let formattedAmount = String(format: "€%.2f", amount)
        showNotification(
            title: "Transfer Sent",
            message: "\(formattedAmount) sent to \(recipient.isEmpty ? "Recipient" : recipient)",
            iconName: "checkmark.circle.fill",
            isSuccess: true
        )
        return true
    }

    func depositMoney(amount: Double, source: String) {
        guard amount > 0 else { return }
        account.balance += amount
        let newTx = Transaction(
            title: source.isEmpty ? "Instant Top-Up" : source,
            subtitle: "Account Deposit",
            amount: amount,
            date: Date(),
            category: .income,
            type: .income,
            recipientIBAN: account.iban,
            note: "Deposit via \(source)",
            iconName: "arrow.down.circle.fill"
        )
        transactions.insert(newTx, at: 0)

        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        let formattedAmount = String(format: "€%.2f", amount)
        showNotification(
            title: "Deposit Received",
            message: "\(formattedAmount) credited to your account",
            iconName: "arrow.down.circle.fill",
            isSuccess: true
        )
    }

    func toggleCardFreeze(cardID: UUID) {
        if let idx = cards.firstIndex(where: { $0.id == cardID }) {
            cards[idx].isFrozen.toggle()
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            let status = cards[idx].isFrozen ? "Frozen" : "Unfrozen"
            showNotification(
                title: "Card \(status)",
                message: "\(cards[idx].cardType) is now \(status.lowercased())",
                iconName: cards[idx].isFrozen ? "snowflake" : "checkmark.shield.fill",
                isSuccess: !cards[idx].isFrozen
            )
        }
    }

    func resetToDefaults() {
        account = BankAccount(balance: 82.87)
        transactions = Self.seedTransactions()
        userProfile = UserProfile(name: "047", tag: "@047")
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        showNotification(
            title: "Data Reset",
            message: "Account balance restored to €82.87",
            iconName: "arrow.clockwise.circle.fill",
            isSuccess: true
        )
    }

    private func showNotification(title: String, message: String, iconName: String = "bell.fill", isSuccess: Bool = true) {
        withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
            self.activeNotification = InAppNotification(
                title: title,
                message: message,
                iconName: iconName,
                isSuccess: isSuccess
            )
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) { [weak self] in
            guard let self else { return }
            withAnimation(.easeInOut(duration: 0.3)) {
                if self.activeNotification?.title == title {
                    self.activeNotification = nil
                }
            }
        }
    }

    private func saveAccount() {
        if let data = try? JSONEncoder().encode(account) {
            UserDefaults.standard.set(data, forKey: accountKey)
        }
    }

    private func saveTransactions() {
        if let data = try? JSONEncoder().encode(transactions) {
            UserDefaults.standard.set(data, forKey: transactionsKey)
        }
    }

    private func saveCards() {
        if let data = try? JSONEncoder().encode(cards) {
            UserDefaults.standard.set(data, forKey: cardsKey)
        }
    }

    private func saveProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: profileKey)
        }
    }
}
