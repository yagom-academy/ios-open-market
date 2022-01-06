import Foundation

enum WorkType {
    static let apiHost: String = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case checkProductDetail(id: Int)
    case checkProductList
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URL(string: WorkType.apiHost + "healthChecker")
        case .checkProductDetail(let id):
            return URL(string: WorkType.apiHost + "api/products/" + "\(id)")
        case .checkProductList:
            return URL(string: WorkType.apiHost + "api/products?page-no=1&items-per-page=10")
        }
    }
    
}
