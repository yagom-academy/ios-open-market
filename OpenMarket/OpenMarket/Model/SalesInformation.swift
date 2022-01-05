import Foundation

struct SalesInformation: Codable {
    var name: String
    var descriptions: String
    var price: Double
    var currency: Currency
    var discountedPrice: Double?
    var stock: Int?
    var secret: String
}
