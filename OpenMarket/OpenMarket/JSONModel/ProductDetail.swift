//
//  ProductDetail.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/08/09.
//

import UIKit

struct ProductDetail: Decodable {
    let id: Int
    let vendorID: Int
    let name: String
    let description: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let images: [ProductImage]
    let vendors: Vendors
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case description
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
        case images
        case vendors
        case createdAt = "created_at"
        case issuedAt = "issued_at"
    }
}

extension ProductDetail {
    func makePriceText() -> NSMutableAttributedString {
        let price = "\(self.currency.rawValue) \(self.price.formatNumber())"
        
        let bargainPrice = "\n\(self.currency.rawValue) \(self.bargainPrice.formatNumber())"
        
        if self.bargainPrice == self.price {
            return NSMutableAttributedString().makeBargainPriceText(string: price)
        } else {
            return NSMutableAttributedString()
                .makePriceText(string: price)
                .makeBargainPriceText(string: bargainPrice)
        }
    }
    
    func makeStockText() -> NSMutableAttributedString {
        if self.stock == 0 {
            let stockText = PriceText.soldOut.detailText
            let muttableAttributedString = NSMutableAttributedString(string: stockText)
            
            let attributes: [NSAttributedString.Key: Any] =
            [
                .font: UIFont.preferredFont(forTextStyle: .title3),
                .foregroundColor: UIColor.systemOrange
            ]
            
            muttableAttributedString.addAttributes(attributes,
                                                   range: NSMakeRange(0, stockText.count))
            
            return muttableAttributedString
        } else {
            let stockText = "\(PriceText.stock.detailText)\(stock)"
            let muttableAttributedString = NSMutableAttributedString(string: stockText)
            
            let attributes: [NSAttributedString.Key: Any] =
            [
                .font: UIFont.preferredFont(forTextStyle: .title3),
                .foregroundColor: UIColor.systemGray
            ]
            
            muttableAttributedString.addAttributes(attributes,
                                                   range: NSMakeRange(0, stockText.count))
            
            return muttableAttributedString
        }
    }
}

private extension NSMutableAttributedString {
    func makePriceText(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
        [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemRed
        ]
        
        self.append(NSAttributedString(string: string,
                                       attributes: attributes))
        
        return self
    }
    
    func makeBargainPriceText(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
        [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.systemGray
        ]
        
        self.append(NSAttributedString(string: string,
                                       attributes: attributes))
        
        return self
    }
}


