import Foundation

struct BankAccount: Identifiable, Codable {
    let id: UUID
    var name: String
    var iban: String
    var bic: String
    var balance: Double
    var currency: String

    init(
        id: UUID = UUID(),
        name: String = "Main Account",
        iban: String = "DE12 3456 7890 1234 5678 90",
        bic: String = "XENZDEFFXXX",
        balance: Double = 82.87,
        currency: String = "€"
    ) {
        self.id = id
        self.name = name
        self.iban = iban
        self.bic = bic
        self.balance = balance
        self.currency = currency
    }

    var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = currency
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: NSNumber(value: balance)) ?? "\(currency)\(String(format: "%.2f", balance))"
    }

    var formattedIBAN: String {
        iban
    }
}
