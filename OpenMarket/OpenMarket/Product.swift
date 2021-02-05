
import Foundation

struct Product: Codable {
    let id: Int?
    let title: String
    let descriptions: String?
    let price: Int
    let currency: String
    let stock: Int
    let discountedPrice: Int?
    let thumbnails: [String]?
    let images: [Data]?
    let registrationDate: Double?
    let password: String?
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case descriptions
        case price
        case currency
        case stock
        case discountedPrice = "discounted_price"
        case thumbnails
        case images
        case registrationDate = "registration_date"
        case password
    }
}
