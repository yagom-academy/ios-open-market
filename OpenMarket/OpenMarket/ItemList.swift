
import Foundation

struct ItemList: Decodable {
    let page: Int
    let items: [Item]
}
