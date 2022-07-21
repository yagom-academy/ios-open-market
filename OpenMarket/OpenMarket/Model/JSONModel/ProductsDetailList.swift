//
//  ProductsDetailList.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/12.
//

import UIKit

struct ProductsDetailList: Codable {
    let pageNumber: Int
    let itemsPerPage: Int
    let totalCount: Int
    let offset: Int
    let limit: Int
    let pages: [ProductDetail]
    let lastPage: Int
    let hasNext: Bool
    let hasPrev: Bool
    
    private enum CodingKeys: String, CodingKey {
        case pageNumber = "page_no"
        case itemsPerPage = "items_per_page"
        case totalCount = "total_count"
        case offset
        case limit
        case pages
        case lastPage = "last_page"
        case hasNext = "has_next"
        case hasPrev = "has_prev"
    }
}

extension ProductDetail {
    func setPriceText() -> NSMutableAttributedString {
        let price = "\(self.currency.rawValue) \(self.price.formatNumber())"
        let bargainPrice = "\n\(self.currency.rawValue) \(self.bargainPrice.formatNumber())"
        
        if self.bargainPrice == 0 {
            return NSMutableAttributedString().makeBargainPriceText(string: price)
        } else {
            return NSMutableAttributedString()
                .makePriceText(string: price)
                .makeBargainPriceText(string: bargainPrice)
        }
    }
    
    func setThumbnailImage() -> UIImage {
        guard let url = URL(string: self.thumbnail),
                let data = try? Data(contentsOf: url),
                let image = UIImage(data: data) else {  return UIImage() }
        
        return image
    }
    
    func setStockText() -> NSMutableAttributedString {
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
