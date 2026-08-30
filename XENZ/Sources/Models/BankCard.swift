import Foundation
import SwiftUI

enum CardTheme: String, CaseIterable, Codable {
    case obsidianMetal = "Obsidian Metal"
    case titaniumSilver = "Titanium Silver"
    case cyberNeon      = "Cyber Neon"
    case midnightGold   = "Midnight Gold"

    var gradientColors: [Color] {
        switch self {
        case .obsidianMetal:
            return [Color(white: 0.16), Color(white: 0.06), Color.black]
        case .titaniumSilver:
            return [Color(white: 0.35), Color(white: 0.18), Color(white: 0.08)]
        case .cyberNeon:
            return [Color(red: 0.10, green: 0.25, blue: 0.35), Color(white: 0.06), Color.black]
        case .midnightGold:
            return [Color(red: 0.30, green: 0.25, blue: 0.10), Color(white: 0.07), Color.black]
        }
    }
}

struct BankCard: Identifiable, Codable {
    let id: UUID
    var cardholderName: String
    var cardNumber: String
    var expiryDate: String
    var cvv: String
    var cardType: String
    var theme: CardTheme
    var isFrozen: Bool
    var monthlyLimit: Double
    var currentSpent: Double
    var isOnlinePaymentsEnabled: Bool
    var isContactlessEnabled: Bool

    init(
        id: UUID = UUID(),
        cardholderName: String = "047",
        cardNumber: String = "4729 8819 0470 4072",
        expiryDate: String = "08/29",
        cvv: String = "470",
        cardType: String = "Black Metal Debit",
        theme: CardTheme = .obsidianMetal,
        isFrozen: Bool = false,
        monthlyLimit: Double = 1500.0,
        currentSpent: Double = 312.45,
        isOnlinePaymentsEnabled: Bool = true,
        isContactlessEnabled: Bool = true
    ) {
        self.id = id
        self.cardholderName = cardholderName
        self.cardNumber = cardNumber
        self.expiryDate = expiryDate
        self.cvv = cvv
        self.cardType = cardType
        self.theme = theme
        self.isFrozen = isFrozen
        self.monthlyLimit = monthlyLimit
        self.currentSpent = currentSpent
        self.isOnlinePaymentsEnabled = isOnlinePaymentsEnabled
        self.isContactlessEnabled = isContactlessEnabled
    }

    var maskedNumber: String {
        let clean = cardNumber.replacingOccurrences(of: " ", with: "")
        if clean.count >= 4 {
            let last4 = String(clean.suffix(4))
            return "•••• •••• •••• \(last4)"
        }
        return "•••• •••• •••• 4072"
    }
}
