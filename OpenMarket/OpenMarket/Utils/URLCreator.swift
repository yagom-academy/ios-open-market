import Foundation

enum URLCreator {
    static let baseURL = "https://market-training.yagom-academy.kr/api/products"
    
    case productDetail(id: Int)
    case productUpdate(id: Int)
    case productList(pageNo: Int, itemsPerPage: Int)
    case productRegister
    case deleteProduct(id: Int, secret: String)
    case productSecret(id: Int)
    
    var url: URL? {
        switch self {
        case .productDetail(let id), .productUpdate(let id):
            return URL(string: URLCreator.baseURL + "/\(id)")
        case .productList(let pageNo, let itemsPerPage):
            var components = URLComponents(string: URLCreator.baseURL)
            let pageNo = URLQueryItem(name: "page_no", value: "\(pageNo)")
            let itemsPerPage = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
            components?.queryItems = [pageNo, itemsPerPage]
            return components?.url
        case .productRegister:
            return URL(string: URLCreator.baseURL)
        case .deleteProduct(let id, let secret):
            return URL(string: URLCreator.baseURL + "/\(id)" + "/\(secret)")
        case .productSecret(let id):
            return URL(string: URLCreator.baseURL + "/\(id)" + "/secret")
        }
    }
}
