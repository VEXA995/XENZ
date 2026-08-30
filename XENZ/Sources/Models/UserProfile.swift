import Foundation

struct UserProfile: Codable {
    var name: String
    var tag: String
    var email: String
    var phone: String
    var isBiometricsEnabled: Bool
    var isPushNotificationsEnabled: Bool
    var defaultCurrency: String

    init(
        name: String = "047",
        tag: String = "@047",
        email: String = "047@xenz.bank",
        phone: String = "+49 170 0470470",
        isBiometricsEnabled: Bool = true,
        isPushNotificationsEnabled: Bool = true,
        defaultCurrency: String = "€"
    ) {
        self.name = name
        self.tag = tag
        self.email = email
        self.phone = phone
        self.isBiometricsEnabled = isBiometricsEnabled
        self.isPushNotificationsEnabled = isPushNotificationsEnabled
        self.defaultCurrency = defaultCurrency
    }
}
