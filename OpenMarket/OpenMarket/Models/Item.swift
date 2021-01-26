import Foundation

enum Currency: String, Codable {
    case KRW = "KRW"
    case USD = "USD"
}

struct Item: Codable {
    let id: UInt
    let title: String
    let price: UInt
    let currency: Currency
    let stock: UInt
    let thumbnails: [String]
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails
        case registrationDate = "registration_date"
    }
}
