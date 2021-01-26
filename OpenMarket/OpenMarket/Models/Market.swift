import Foundation

struct Market: Decodable {
    let page: UInt
    let goodsList: [Goods]
    
    enum CodingKeys: String, CodingKey {
        case page
        case goodsList = "items"
    }
}
