import Foundation

enum URLManager {
    
    static let apiHost: String = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case editOrCheckProductDetail(id: Int)
    case checkProductList(pageNumber: Int, itemsPerPage: Int)
    case addNewProduct
    case deleteProduct(id: Int, secret: String)
    case checkProductSecret(id: Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URL(string: URLManager.apiHost + "healthChecker")
        case .editOrCheckProductDetail(let id):
            return URL(string: URLManager.apiHost + "api/products/" + "\(id)")
        case .checkProductList(let pageNumber, let itemsPerPage):
            var components = URLComponents(string: URLManager.apiHost + "api/products")
            let number = URLQueryItem(name: "page_no", value: "\(pageNumber)")
            let items = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            components?.queryItems = [number, items]
            return components?.url
        case .addNewProduct:
            return URL(string: URLManager.apiHost + "api/products")
        case .deleteProduct(let id, let secret):
            return URL(string: URLManager.apiHost + "api/products/" + "\(id)/" + "\(secret)")
        case .checkProductSecret(let id):
            return URL(string: URLManager.apiHost + "api/products/" + "\(id)/" + "secret")
        }
    }
    
}
