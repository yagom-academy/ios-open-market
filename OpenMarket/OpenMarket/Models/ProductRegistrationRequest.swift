import Foundation

struct ProductRegistrationRequest: MultipartUploadable {
    let name: String
    let descriptions: String
    let price: Int
    let currency: Currency
    let discountedPrice: Int
    let stock: Int
    let secret: String

    enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}

protocol MultipartUploadable: Encodable {}
