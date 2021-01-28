import Foundation

struct MarketGoods: Decodable {
    let page: UInt
    let list: [Goods]
    
    enum CodingKeys: String, CodingKey {
        case page
        case list = "items"
    }
}
