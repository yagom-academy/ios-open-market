import Foundation

enum OpenMarketAPITypes {
    case fetchGoodsList
    case registerGoods
    case fetchGoods
    case editGoods
    case removeGoods
    
    var urlPath: String {
        switch self {
        case .fetchGoodsList:
            return "/items/"
        case .registerGoods:
            return "/item"
        case .fetchGoods:
            return "/item/"
        case .editGoods:
            return "/item/"
        case .removeGoods:
            return "/item/"
        }
    }
}
