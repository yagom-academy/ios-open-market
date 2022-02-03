import UIKit
import JNomaKit

class PriceLabel: UILabel {
    
    enum LayoutAttribute {
        enum PriceLabel {
            static let textStyle: UIFont.TextStyle = .callout
            static let originalPriceFontColor: UIColor = .red
            static let bargainPriceFontColor: UIColor = .systemGray
        }
    }
    
    enum Direction {
        case vertical
        case horizontal
    }

    func setText(currency: String, originalPrice: Double, discountedPrice: Double, direction: Direction) {
        let blank = NSMutableAttributedString(string: " ")
        let lineBreak = NSMutableAttributedString(string: "\n")
        let result = NSMutableAttributedString(string: "")
        if originalPrice != discountedPrice {
            let originalCurrency = JNAttributedStringMaker.attributedString(
                text: "\(currency) ",
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.originalPriceFontColor,
                attributes: [.strikeThrough]
            )
            let originalPrice = JNAttributedStringMaker.attributedString(
                text: originalPrice.description,
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.originalPriceFontColor,
                attributes: [.decimal, .strikeThrough]
            )
            let discountedCurrency = JNAttributedStringMaker.attributedString(
                text: "\(currency) ",
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor
            )
            let discountedPrice = JNAttributedStringMaker.attributedString(
                text: discountedPrice.description,
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor,
                attributes: [.decimal]
            )
            result.append(originalCurrency)
            result.append(originalPrice)
            
            if direction == .vertical {
                result.append(lineBreak)
            } else if direction == .horizontal {
                result.append(blank)
            }
            
            result.append(discountedCurrency)
            result.append(discountedPrice)
        } else {
            let discountedCurrency = JNAttributedStringMaker.attributedString(
                text: "\(currency) ",
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor
            )
            let discountedPrice = JNAttributedStringMaker.attributedString(
                text: discountedPrice.description,
                textStyle: LayoutAttribute.PriceLabel.textStyle,
                fontColor: LayoutAttribute.PriceLabel.bargainPriceFontColor,
                attributes: [.decimal]
            )
            
            result.append(discountedCurrency)
            result.append(discountedPrice)
        }

        self.attributedText = result
    }
}
