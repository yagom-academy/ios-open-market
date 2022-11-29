//  Created by Aejong, Tottale on 2022/11/15.


import UIKit

protocol NSAttributeProtocol {
    func fetchPriceNSAttributedString(from product: Product) -> NSAttributedString
    func fetchLineBreakedPriceNSAttributedString(from product: Product) -> NSAttributedString
}

extension NSAttributeProtocol {
    func fetchPriceNSAttributedString(from product: Product) -> NSAttributedString {
        var priceText = "\(product.currency) \(product.price.decimalInt) "
        var attributedStr = NSMutableAttributedString(string: priceText)
        if product.bargainPrice != product.price {
            priceText += "\(product.currency) \(product.bargainPrice.decimalInt)"
            attributedStr = NSMutableAttributedString(string: priceText)
            attributedStr.addAttributes([.strikethroughStyle: 1,
                                         .foregroundColor: UIColor.systemRed],
                                        range: (priceText as NSString).range(of: "\(product.currency) \(product.price.decimalInt)"))
        }
        
        return attributedStr
    }
    
    func fetchLineBreakedPriceNSAttributedString(from product: Product) -> NSAttributedString {
        var priceText = "\(product.currency) \(product.price.decimalInt)\n"
        var attributedStr = NSMutableAttributedString(string: priceText)
        if product.bargainPrice != product.price {
            priceText += "\(product.currency) \(product.bargainPrice.decimalInt)"
            attributedStr = NSMutableAttributedString(string: priceText)
            attributedStr.addAttributes([.strikethroughStyle: 1,
                                         .foregroundColor: UIColor.systemRed],
                                        range: (priceText as NSString).range(of: "\(product.currency) \(product.price.decimalInt)"))
        }
        
        return attributedStr
    }
}
