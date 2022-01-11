import UIKit

struct AttributedTextCreator {
    static func createPriceText(product: ProductDetail?) -> NSMutableAttributedString? {
        guard let product = product else {
            return nil
        }
        
        let priceAttributedText = NSMutableAttributedString()
        let spacing = " "
        
        if product.discountedPrice == 0 {
            return NSMutableAttributedString
                .normalStyle(string: "\(product.currency) \(product.price)")
        }
        
        priceAttributedText.append(NSMutableAttributedString
                            .strikeThroughStyle(string: "\(product.currency) \(product.price)"))
        priceAttributedText.append(NSMutableAttributedString.normalStyle(string: spacing))
        priceAttributedText.append(NSMutableAttributedString
                            .normalStyle(string: "\(product.currency) \(product.bargainPrice)"))
        
        return priceAttributedText
    }
    
    static func createStockText(product: ProductDetail?) -> NSMutableAttributedString? {
        let soldOut = "품절"
        
        guard let product = product else {
            return nil
        }
        
        if product.stock == 0 {
            let attributedString = NSMutableAttributedString(string: soldOut)
            attributedString.addAttribute(.foregroundColor, value: UIColor.orange, range: NSRange(location: 0, length: soldOut.count))
            
            return attributedString
        }
        
        return NSMutableAttributedString
            .normalStyle(string: "잔여수량 : \(product.stock)")
    }
}
