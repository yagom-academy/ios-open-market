import Foundation

struct NetworkConfig {
    static let openMarketFixedURL = "https://camp-open-market.herokuapp.com"
    
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
    
    static func makeURLPath(api: OpenMarketAPITypes, with pathParameter: UInt?) -> String {
        var pathString = api.urlPath
        if let parameter = pathParameter {
            pathString.append(String(parameter))
        }
        return pathString
    }
}
