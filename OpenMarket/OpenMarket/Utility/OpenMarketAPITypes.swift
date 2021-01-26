import Foundation

enum OpenMarketAPITypes {
    case searchGoodsList(page: Int)
    case registerGoods
    case searchGoods(id: Int)
    case editGoods(id: Int)
    case deleteGoods(id: Int)
    
    var urlQuery: String {
        switch self {
        case .searchGoodsList(page: let page):
            return "/items/\(page)"
        case .registerGoods:
            return "/item"
        case .searchGoods(id: let id):
            return "/item/\(id)"
        case .editGoods(id: let id):
            return "/item/\(id)"
        case .deleteGoods(id: let id):
            return "/item/\(id)"
        }
    }
}
