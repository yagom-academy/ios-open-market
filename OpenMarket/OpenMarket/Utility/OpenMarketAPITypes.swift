import Foundation

enum OpenMarketAPITypes {
    case fetchGoodsList(page: UInt)
    case registerGoods
    case fetchGoods(id: UInt)
    case editGoods(id: UInt)
    case removeGoods(id: UInt)
    
    var urlPath: String {
        switch self {
        case .fetchGoodsList(let page):
            return "/items/\(page)"
        case .registerGoods:
            return "/item"
        case .fetchGoods(let id):
            return "/item/\(id)"
        case .editGoods(let id):
            return "/item/\(id)"
        case .removeGoods(let id):
            return "/item/\(id)"
        }
    }
}
