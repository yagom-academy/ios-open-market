import Foundation

enum OpenMarketAPITypes {
    case fetchGoodsList(page: UInt)
    case registerGoods
    case fetchGoods(id: UInt)
    case editGoods(id: UInt)
    case removeGoods(id: UInt)
    
    var urlQuery: String {
        switch self {
        case .fetchGoodsList(page: let page):
            return "/items/\(page)"
        case .registerGoods:
            return "/item"
        case .fetchGoods(id: let id):
            return "/item/\(id)"
        case .editGoods(id: let id):
            return "/item/\(id)"
        case .removeGoods(id: let id):
            return "/item/\(id)"
        }
    }
}
