//
//  Product.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import UIKit

struct ProductData: Decodable, Hashable {
    let identifier: Int
    let vendorIdentifier: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let createdDate: String
    let issuedDate: String
    let vendorName: String?
    let description: String?
    let images: [ImageData]?
    let vendors: VendorData?
    
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case vendorIdentifier = "vendorId"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice
        case discountedPrice
        case stock
        case createdDate = "createdAt"
        case issuedDate = "issuedAt"
        case vendorName
        case description
        case images
        case vendors
    }
    
    enum Currency: String, Codable {
        case USD
        case KRW
        case JPY
    }
}

extension ProductData {
    var currencyAndPrice: String {
        return "\(currency.rawValue) \(price)"
    }
    
    var currencyAndDiscountedPrice: NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: "\(currencyAndPrice) \(currency.rawValue) \(bargainPrice)")
        attributedString.addAttribute(.foregroundColor, value: UIColor.systemRed, range: (currencyAndPrice as NSString).range(of: currencyAndPrice))
        attributedString.addAttribute(.strikethroughStyle, value: 1, range: (currencyAndPrice as NSString).range(of: currencyAndPrice))
        return attributedString
    }
}
