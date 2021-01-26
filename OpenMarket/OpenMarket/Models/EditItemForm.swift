import Foundation

struct EditItemForm {
    var title: String?
    var descriptions: String?
    var price: Int?
    var currency: Currency?
    var stock: Int?
    var discountedPrice: Int?
    var images: [String]?
    var password: String?
    
    var convertParameter: [String : Any]? {
        guard let password = password else {
            return nil
        }
        var parameter: [String : Any] = [:]
        parameter["password"] = password
        
        if let title = title {
            parameter["title"] = title
        }
        if let descriptions = descriptions {
            parameter["descriptions"] = descriptions
        }
        if let price = price {
            parameter["price"] = price
        }
        if let currency = currency {
            parameter["currency"] = currency
        }
        if let stock = stock {
            parameter["stock"] = stock
        }
        if let discountedPrice = discountedPrice {
            parameter["discounted_price"] = discountedPrice
        }
        if let images = images {
            parameter["images"] = images
        }
        
        return parameter
    }
    
}
