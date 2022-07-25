//
//  ProductDetail.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import UIKit

struct ProductDetail: Codable, Hashable {
    let id: Int
    let vendorID: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createdAt: String
    let issuedAt: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case vendorID = "vendor_id"
        case name
        case thumbnail
        case currency
        case price
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case stock
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
    
    func pushThumbnailImageCache() {
        let request = OpenMarketRequest(method: .get, baseURL: self.thumbnail)
        let session = MyURLSession()
        session.execute(with: request) { (result: Result<Data, Error>) in
            switch result {
            case .success(let success):
                guard let image = UIImage(data: success) else { return }
                if ImageCacheManager.shared.object(forKey: NSString(string: self.thumbnail)) == nil {
                    ImageCacheManager.shared.setObject(image, forKey: NSString(string: self.thumbnail))
                }
            case .failure(let failure):
                print(failure.localizedDescription)
            }
        }
    }
    
    func makeStockText() -> NSMutableAttributedString {
        if self.stock == 0 {
            let stockText = PriceText.soldOut.text
            let muttableAttributedString = NSMutableAttributedString(string: stockText)
            let attributes: [NSAttributedString.Key: Any] =
            [
                .font: UIFont.preferredFont(forTextStyle: .footnote),
                .foregroundColor: UIColor.systemOrange
            ]
            
            muttableAttributedString.addAttributes(attributes, range: NSMakeRange(0, stockText.count))
            
            return muttableAttributedString
        } else {
            let stockText = "\(PriceText.stock.text)\(stock)"
            let muttableAttributedString = NSMutableAttributedString(string: stockText)
            let attributes: [NSAttributedString.Key: Any] =
            [
                .font: UIFont.preferredFont(forTextStyle: .footnote),
                .foregroundColor: UIColor.systemGray
            ]
            
            muttableAttributedString.addAttributes(attributes, range: NSMakeRange(0, stockText.count))
            
            return muttableAttributedString
        }
    }
}

private extension NSMutableAttributedString {
    func makePriceText(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
        [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .strikethroughStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: UIColor.systemRed
        ]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
    
    func makeBargainPriceText(string: String) -> NSMutableAttributedString {
        let attributes: [NSAttributedString.Key: Any] =
        [
            .font: UIFont.preferredFont(forTextStyle: .footnote),
            .foregroundColor: UIColor.systemGray
        ]
        self.append(NSAttributedString(string: string, attributes: attributes))
        return self
    }
}
