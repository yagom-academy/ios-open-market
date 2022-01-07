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
            return createURLQuery(queries: ["page_no": "\(pageNo)", "items_per_page": "\(itemsPerPage)"])
        case .productRegister:
            return URL(string: URLCreator.baseURL)
        case .deleteProduct(let id, let secret):
            return URL(string: URLCreator.baseURL + "/\(id)" + "/\(secret)")
        case .productSecret(let id):
            return URL(string: URLCreator.baseURL + "/\(id)" + "/secret")
        }
    }
}

extension URLCreator {
    private func createURLQuery(queries: [String: String]) -> URL? {
        var components = URLComponents(string: URLCreator.baseURL)
        
        queries.forEach { query in
            let queryItem = URLQueryItem(name: query.key, value: query.value)
            components?.queryItems?.append(queryItem)
        }
        
        return components?.url
    }
}
