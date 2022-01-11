//
//  UserDefaultUtility.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/07.
//

import Foundation

struct UserDefaultUtility {
    let userDefaults = UserDefaults()
    static let vendorIdentification = "KEY_VENDOR_ID"
    static let vendorPassword = "KEY_VENDOR_PASSWORD"

    func setVendorIdentification(_ identification: String) {
        self.userDefaults.set(identification, forKey: UserDefaultUtility.vendorIdentification)
    }

    func getVendorIdentification() throws -> String {
        guard let identification = self.userDefaults.string(forKey: UserDefaultUtility.vendorIdentification) else {
            throw UserError.identificationNotFound
        }
        return identification
    }

    func setVendorPassword(_ password: String) {
        self.userDefaults.set(password, forKey: UserDefaultUtility.vendorPassword)
    }

    func getVendorPassword() throws -> String {
        guard let password = self.userDefaults.string(forKey: UserDefaultUtility.vendorPassword) else {
            throw UserError.passwordNotFound
        }
        return password
    }
}
