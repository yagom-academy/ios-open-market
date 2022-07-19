//
//  ProductDetail+extension.swift
//  OpenMarket
//
//  Created by groot, bard on 2022/07/19.
//

import UIKit

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
