//
//  NewProduct.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/12/01.
//

import Foundation

struct NewProduct: Encodable {
    let name: String
    let description: String
    let currency: CurrencyUnit
    let price: Double
    var discountedPrice: Double? = 0
    var stock: Int? = 0
    let secret: String = "dk9r294wvfwkgvhn"
    
    enum CurrencyUnit: String, Encodable {
        case KRW
        case USD
    }
}
