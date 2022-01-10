import UIKit

struct Product: Decodable {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Double
    let bargainPrice: Double
    let discountedPrice: Double
    let stock: Int
    let images: [Image]?
    let vendor: Vendor?
    let createdAt: Date
    let issuedAt: Date
    
    private enum CodingKeys: String, CodingKey {
        case vendor = "vendors"
        case id, vendorId, name, thumbnail, currency, price, bargainPrice, discountedPrice, stock,
             images, createdAt, issuedAt
    }
}

extension Product {
    var attributedTitle: NSAttributedString {
        return NSAttributedString(
            string: name,
            attributes: [.font: UIFont.preferredFont(forTextStyle: .headline)]
        )
    }
    var attributedPrice: NSAttributedString {
        let result = NSMutableAttributedString()
        if self.bargainPrice == 0.0 {
            let formattedPrice = price.formatted ?? price.description
            let price = NSAttributedString(
                string: currency.rawValue + " " + formattedPrice,
                attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: UIColor.systemGray
                ]
            )
            result.append(price)
            return result
        }
        let formattedOriginalPrice = price.formatted ?? price.description
        let originalPrice = NSAttributedString(
            string: currency.rawValue + " " + formattedOriginalPrice,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.systemRed,
                .strikethroughStyle: NSUnderlineStyle.single.rawValue
            ]
        )
        let formattedBargainPrice = bargainPrice.formatted ?? bargainPrice.description
        let bargainPrice = NSAttributedString(
            string: currency.rawValue + " " + formattedBargainPrice,
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.systemGray
            ]
        )
        let blank = NSAttributedString(string: " ")
        result.append(originalPrice)
        result.append(blank)
        result.append(bargainPrice)
        return result
    }
    var attributedStock: NSAttributedString {
        if stock == 0 {
            let outOfStock = NSAttributedString(
                string: "품절",
                attributes: [
                    .font: UIFont.preferredFont(forTextStyle: .body),
                    .foregroundColor: UIColor.systemOrange
                ]
            )
            return outOfStock
        }
        let currentStock = NSAttributedString(
            string: "잔여수량 : \(stock)",
            attributes: [
                .font: UIFont.preferredFont(forTextStyle: .body),
                .foregroundColor: UIColor.systemGray
            ]
        )
        return currentStock
    }
}

private extension Double {
    var formatted: String? {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(for: self)
    }
}
