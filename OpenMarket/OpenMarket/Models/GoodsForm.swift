import Foundation

struct GoodsForm: Encodable {
    var title: String? = nil
    var descriptions: String? = nil
    var price: Int? = nil
    var currency: String? = nil
    var stock: Int? = nil
    var discountedPrice: Int? = nil
    var images: [String]? = nil
    var password: String? = nil
    var id: UInt? = nil

    enum CodingKeys: String, CodingKey {
        case title, price, currency, stock, descriptions, images, password, id
        case discountedPrice = "discounted_price"
    }
    
    init(title: String?, descriptions: String?, price: Int?, currency: String?, stock: Int?, discountedPrice: Int?, images: [String]?, password: String) {
        self.title = title
        self.descriptions = descriptions
        self.price = price
        self.currency = currency
        self.stock = stock
        self.discountedPrice = discountedPrice
        self.images = images
        self.password = password
    }
    
    init(id: UInt, password: String) {
        self.id = id
        self.password = password
    }
}
