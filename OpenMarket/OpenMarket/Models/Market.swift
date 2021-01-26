import Foundation

struct Market: Codable {
    let page: UInt
    let itemList: [Item]
    
    enum CodingKeys: String, CodingKey {
        case page
        case itemList = "items"
    }
}
