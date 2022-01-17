//
//  Int+extension.swift
//  OpenMarket
//
//  Created by Ari on 2022/01/10.
//

import UIKit

extension Double {
    var fomattedString: String {
        let numberfommater = NumberFormatter()
        numberfommater.numberStyle = .decimal
        return numberfommater.string(for: self) ?? self.description
    }
}
