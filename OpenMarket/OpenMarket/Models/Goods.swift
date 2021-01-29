import Foundation

struct Goods: Decodable {
    let id: UInt
    let title: String
    let price: UInt
    let currency: String
    let images: [String]?
    let descriptions: String?
    let discountedPrice: UInt?
    let stock: UInt
    let thumbnails: [String]
    let registrationDate: Double
    
    enum CodingKeys: String, CodingKey {
        case id, title, price, currency, stock, thumbnails, descriptions, images
        case registrationDate = "registration_date"
        case discountedPrice = "discounted_price"
    }
}

protocol GoodsForm {
    var password: String { get }
    
    func convertParameter() -> [String : Any]
}

protocol registerGoodsForm: GoodsForm {
    var title: String { get }
    var descriptions: String { get }
    var price: Int { get }
    var currency: String { get }
    var stock: Int { get }
    var discountedPrice: Int? { get }
    var images: [Data] { get }
}

protocol editGoodsForm: GoodsForm {
    var title: String? { get }
    var descriptions: String? { get }
    var price: Int? { get }
    var currency: String? { get }
    var stock: Int? { get }
    var discountedPrice: Int? { get }
    var images: [Data]? { get }
    var id: UInt { get }
}

protocol deleteGoodsForm: GoodsForm {
    var id: UInt { get }
}
