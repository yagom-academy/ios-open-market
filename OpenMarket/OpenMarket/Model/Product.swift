import UIKit

struct Product: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let description: String?
    let thumbnail: String
    let currency: Currency
    let price: Decimal
    let bargainPrice: Decimal
    let discountedPrice: Decimal
    let stock: Int
    let images: [Image]?
    let vendor: Vendor?
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case vendor = "vendors"
        case id, vendorId, name, description, thumbnail, currency, price, bargainPrice,
             discountedPrice, stock, images, createdAt, issuedAt
    }
}

extension Product {
    private var formattedOriginalPrice: NSAttributedString {
        let formattedPrice = price.formatted ?? price.description
        let price = NSAttributedString(
            string: currency.rawValue + "\u{A0}" + formattedPrice,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.systemGray
            ]
        )
        return price
    }
    private var strikethroughPrice: NSAttributedString {
        let strikethroughPrice = NSMutableAttributedString(
            attributedString: formattedOriginalPrice
        )
        strikethroughPrice.addAttributes(
            [
                .foregroundColor: UIColor.systemRed,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ],
            range: NSRange(location: 0, length: strikethroughPrice.length)
        )
        return strikethroughPrice
    }
    private var formattedBargainPrice: NSAttributedString {
        let formattedBargainPrice = bargainPrice.formatted ?? bargainPrice.description
        let bargainPrice = NSAttributedString(
            string: currency.rawValue + "\u{A0}" + formattedBargainPrice,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.systemGray
            ]
        )
        return bargainPrice
    }
    private var outOfStock: NSAttributedString {
        let outOfStock = NSAttributedString(
            string: "품절",
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.systemOrange
            ]
        )
        return outOfStock
    }
    private var currentStock: NSAttributedString {
        let currentStock = NSAttributedString(
            string: "잔여수량 : \(stock)",
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.systemGray
            ]
        )
        return currentStock
    }
    
    var attributedTitle: NSAttributedString {
        return NSAttributedString(
            string: name,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)]
        )
    }
    var attributedPrice: NSAttributedString {
        if self.discountedPrice == 0.0 {
            return formattedOriginalPrice
        }
        
        let priceWithBargainPrice = NSMutableAttributedString()
        let blank = NSAttributedString(string: " ")
        
        priceWithBargainPrice.append(strikethroughPrice)
        priceWithBargainPrice.append(blank)
        priceWithBargainPrice.append(formattedBargainPrice)
        return priceWithBargainPrice
    }
    var attributedStock: NSAttributedString {
        let isOutOfStock: Bool = (stock == 0)
        return isOutOfStock ? outOfStock : currentStock
    }
}

private extension Decimal {
    var formatted: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self)
    }
}
