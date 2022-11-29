//
//  String+.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/29.
//

extension String {
    func isNumber() -> Bool {
        for character in self {
            if character.isNumber == false {
                return false
            }
        }
        return true
    }
}
