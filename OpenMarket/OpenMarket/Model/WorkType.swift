import Foundation

enum WorkType {
    static let apiHost: String = "https://market-training.yagom-academy.kr/"
    case healthChecker
    case checkProductDetail(id: Int)
    case checkProductList(pageNumber: Int, itemsPerPage: Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URL(string: WorkType.apiHost + "healthChecker")
        case .checkProductDetail(let id):
            return URL(string: WorkType.apiHost + "api/products/" + "\(id)")
        case .checkProductList(let pageNumber, let itemsPerPage):
            var components = URLComponents(string: WorkType.apiHost + "api/products")
            let number = URLQueryItem(name: "page_no", value: "\(pageNumber)")
            let items = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            components?.queryItems = [number, items]
            return components?.url
        }
    }
    
}
