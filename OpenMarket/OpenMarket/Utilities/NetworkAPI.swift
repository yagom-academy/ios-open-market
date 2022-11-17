//  Created by Aejong, Tottale on 2022/11/15.

import Foundation

enum NetworkAPI {
    
    static let scheme = "https"
    static let host = "openmarket.yagom-academy.kr"
    
    case productList(query: [Query: String]?)
    case product(productID: Int)
    case healthCheck
    
    var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkAPI.scheme
        urlComponents.host = NetworkAPI.host
        switch self {
        case .productList(let query):
            urlComponents.path = "/api/products"
            if let query = query {
                urlComponents.setQueryItems(with: query)
            }
        case .product(let productID):
            urlComponents.path = "/api/products/\(productID)"
        case .healthCheck:
            urlComponents.path = "/healthChecker"
        }
        return urlComponents
    }
}

enum Query: String {
    case pageNumber = "page_no"
    case itemsPerPage = "items_per_page"
    case searchFilter = "search_value"
}
