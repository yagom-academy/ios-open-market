import Foundation

struct Market: Decodable {
    let page: UInt
    let itemList: [Goods]
    
    enum CodingKeys: String, CodingKey {
        case page
        case itemList = "items"
    }
}
