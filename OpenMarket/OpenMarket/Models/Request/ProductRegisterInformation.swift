import Foundation

struct ProductRegisterInformation: Codable {
    let name: String
    let description: String
    let price: Double
    let currency: Currency
    let discountedPrice: Double?
    let stock: Int?
    let secret: String
    
    enum CodingKeys: String, CodingKey {
        case discountedPrice = "discounted_price"
        case name, description, price, currency, stock, secret
    }
}
