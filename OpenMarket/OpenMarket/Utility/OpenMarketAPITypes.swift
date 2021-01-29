import Foundation

enum OpenMarketAPITypes: OpenMarketAPI {
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
    
    func choiceHTTPMethod() -> MethodType {
        switch self {
        case .fetchGoodsList:
            return .get
        case .registerGoods:
            return .post
        case .fetchGoods:
            return .get
        case .editGoods:
            return .patch
        case .removeGoods:
            return .delete
        }
    }
}

protocol OpenMarketAPI {
    func choiceHTTPMethod() -> MethodType
}
