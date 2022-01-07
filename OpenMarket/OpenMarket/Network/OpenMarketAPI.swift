import Foundation

enum OpenMarketAPI {
    case productDetail
    case productList
    case productRegister(body: Data, id: String)
    case productUpdate(body: Data, id: String)
    case deleteProduct(id: String)
    case productSecret(body: Data, id: String)
    
    var httpMethod: String {
        switch self {
        case .productDetail, .productList:
            return "GET"
        case .productRegister, .productSecret:
            return "POST"
        case .productUpdate:
            return "PATCH"
        case .deleteProduct:
            return "DELETE"
        }
    }
}
