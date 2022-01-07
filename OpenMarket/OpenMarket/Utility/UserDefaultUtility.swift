//
//  UserDefaultUtility.swift
//  OpenMarket
//
//  Created by yeha on 2022/01/07.
//

import Foundation

struct UserDefaultUtility {
    let userDefaults = UserDefaults()
    static let KEY_VENDOR_ID = "KEY_VENDOR_ID"
    static let KEY_VENDOR_PASSWORD = "KEY_VENDOR_PASSWORD"

    func setVendorIdentification(identification: String) {
        self.userDefaults.set(identification, forKey: UserDefaultUtility.KEY_VENDOR_ID)
    }

    func getVendorIdentification() -> String {
        return self.userDefaults.string(forKey: UserDefaultUtility.KEY_VENDOR_ID) ?? ""
    }

    func setVendorPassword(password: String) {
        self.userDefaults.set(password, forKey: UserDefaultUtility.KEY_VENDOR_PASSWORD)
    }

    func getVendorPassword() -> String {
        return self.userDefaults.string(forKey: UserDefaultUtility.KEY_VENDOR_PASSWORD) ?? ""
    }
}
