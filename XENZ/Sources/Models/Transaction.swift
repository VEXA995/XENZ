import Foundation
import SwiftUI

enum TransactionType: String, Codable {
    case income
    case expense
}

enum TransactionCategory: String, CaseIterable, Codable {
    case gaming        = "Gaming"
    case subscriptions = "Subscriptions"
    case shopping      = "Shopping"
    case foodAndDrinks = "Food & Drinks"
    case transport     = "Transport"
    case income        = "Income"
    case transfer      = "Transfer"
    case other         = "Other"

    var defaultIcon: String {
        switch self {
        case .gaming:        return "gamecontroller.fill"
        case .subscriptions: return "play.tv.fill"
        case .shopping:      return "bag.fill"
        case .foodAndDrinks: return "cup.and.saucer.fill"
        case .transport:     return "tram.fill"
        case .income:        return "briefcase.fill"
        case .transfer:      return "arrow.left.arrow.right"
        case .other:         return "creditcard.fill"
        }
    }
}

struct Transaction: Identifiable, Codable {
    let id: UUID
    var title: String
    var subtitle: String
    var amount: Double
    var date: Date
    var category: TransactionCategory
    var type: TransactionType
    var recipientIBAN: String?
    var note: String?
    var iconName: String

    init(
        id: UUID = UUID(),
        title: String,
        subtitle: String = "",
        amount: Double,
        date: Date = Date(),
        category: TransactionCategory,
        type: TransactionType = .expense,
        recipientIBAN: String? = nil,
        note: String? = nil,
        iconName: String? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle.isEmpty ? category.rawValue : subtitle
        self.amount = amount
        self.date = date
        self.category = category
        self.type = type
        self.recipientIBAN = recipientIBAN
        self.note = note
        self.iconName = iconName ?? category.defaultIcon
    }

    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "€"
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let num = NSNumber(value: amount)
        let formatted = formatter.string(from: num) ?? "€\(String(format: "%.2f", amount))"
        switch type {
        case .income:  return "+ \(formatted)"
        case .expense: return "- \(formatted)"
        }
    }

    var formattedDateString: String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "HH:mm"
            return "Today, \(timeFormatter.string(from: date))"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let df = DateFormatter()
            df.dateFormat = "MMM d, yyyy"
            return df.string(from: date)
        }
    }
}
