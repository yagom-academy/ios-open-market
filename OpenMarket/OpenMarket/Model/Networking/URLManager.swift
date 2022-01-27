import Foundation

enum URLManager {
    private static let apiHost = "https://market-training.yagom-academy.kr/"
    
    case healthChecker
    case productInformation(Int)
    case productList(Int, Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URL(string: "\(URLManager.apiHost)healthChecker")
        case .productInformation(let productID):
            return URL(string: "\(URLManager.apiHost)/api/products/\(productID)" )
        case .productList(let pageNumber, let itemsPerPage):
            return URL(string: "\(URLManager.apiHost)/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)")
        }
    }
}
