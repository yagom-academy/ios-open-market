import Foundation

struct ProductDetail {
    let id: Int
    let vendorId: Int
    let name: String
    let thumbnail: String
    let currency: Currency
    let price: Int
    let bargainPrice: Int
    let discountedPrice: Int
    let stock: Int
    let createAt: Date
    let issuedAt: Date
    
    enum Currency: String {
        case krw = "KRW"
        case usd = "USD"
    }
    
    enum CodingKeys: String, CodingKey {
        case vendorId = "vendor_id"
        case bargainPrice = "bargain_price"
        case discountedPrice = "discounted_price"
        case createAt = "create_at"
        case issuedAt = "issued_at"
        case id, name, thumbnail, currency, price, stock
    }
}


