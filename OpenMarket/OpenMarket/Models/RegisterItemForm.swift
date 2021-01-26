import Foundation

struct RegisterItemForm: Encodable {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: String?
    var stock: Int?
    var discountedPrice: Int?
    var images: [String]?
    var password: String?
    
    var convertParameter: [String : Any]? {
        guard let title = title,
              let descriptions = descriptions,
              let price = price,
              let currency = currency,
              let stock = stock,
              let images = images,
              let password = password else {
            return nil
        }

        var parameter: [String : Any] = [:]
        parameter["title"] = title
        parameter["descriptions"] = descriptions
        parameter["price"] = price
        parameter["currency"] = currency
        parameter["stock"] = stock
        parameter["images"] = images
        parameter["password"] = password

        if let discountedPrice = discountedPrice {
            parameter["discounted_price"] = discountedPrice
        }

        return parameter
    }
}

