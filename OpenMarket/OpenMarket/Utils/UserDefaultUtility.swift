import Foundation

struct UserDefaultUtility {
    let userDefaults = UserDefaults()
    static let vendorIdentification = "KEY_VENDOR_ID"
    static let vendorPassword = "KEY_VENDOR_PASSWORD"

    func setVendorIdentification(_ identification: String) {
        userDefaults.set(identification, forKey: UserDefaultUtility.vendorIdentification)
    }

    func getVendorIdentification() -> String? {
        guard let identification = userDefaults.string(
            forKey: UserDefaultUtility.vendorIdentification
        ) else {
            return nil
        }
        return identification
    }

    func setVendorPassword(_ password: String) {
        userDefaults.set(password, forKey: UserDefaultUtility.vendorPassword)
    }

    func getVendorPassword() throws -> String {
        guard let password = userDefaults.string(forKey: UserDefaultUtility.vendorPassword) else {
            throw UserError.passwordNotFound
        }
        return password
    }
}
