import Foundation

struct ProductModificationRequest: MultipartUploadable {
    var name: String?
    var descriptions: String?
    var thumbnailIdentification: Int?
    var price: Int?
    var currency: Currency?
    var discountedPrice: Int = 0
    var stock: Int = 0
    var secret: String

    enum CodingKeys: String, CodingKey {
        case name
        case descriptions
        case thumbnailIdentification = "thumbnail_id"
        case price
        case currency
        case discountedPrice = "discounted_price"
        case stock
        case secret
    }
}
