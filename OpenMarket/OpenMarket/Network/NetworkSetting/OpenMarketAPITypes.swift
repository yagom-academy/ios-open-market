import Foundation

enum OpenMarketAPITypes {
    case fetchGoodsList
    case registerGoods
    case fetchGoods
    case editGoods
    case deleteGoods
    
    var urlPath: String {
        switch self {
        case .fetchGoodsList:
            return "/items/"
        default:
            return "/item/"
        }
    }
}
