import Foundation

struct RegisterItemForm: Encodable {
    var title: String
    var descriptions: String
    var price: Int
    var currency: String
    var stock: Int
    var discountedPrice: Int?
    var images: [String]
    var password: String
    
    enum CodingKeys: String, CodingKey {
        case title, price, currency, stock, descriptions, images, password
        case discountedPrice = "discounted_price"
    }
}

