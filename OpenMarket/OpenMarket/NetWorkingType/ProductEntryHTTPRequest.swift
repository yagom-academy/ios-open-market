import Foundation

struct ProductEntryHTTPRequest {
    struct Params {
        let name: String
        let descriptions: String
        let price: Int
        let currency: Currency
        let discountedPrice: Int?
        let stock: Int?
        let secret: String
        
        enum CodingKeys: String, CodingKey {
            case name, description, price, currency, stock, secret
            case discountedPrice = "discounted_price"
        }
    }
}

