//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/15.
//

import Foundation

enum Request {
    case healthChecker
    case productList(pageNumber: Int, itemsPerPage: Int )
    case productDetail(productNumber: Int)
    
    var url: URL? {
        switch self {
        case .healthChecker:
            return URLComponents.healthCheckUrl
        case .productList(let pageNumber, let itemsPerPage):
            return URLComponents.marketUrl(path: nil,
                                           queryItems: [URLQueryItem(name: "page_no",
                                                                     value: String(pageNumber)),
                                                        URLQueryItem(name: "items_per_page",
                                                                     value: String(itemsPerPage))])
        case .productDetail(let productNumber):
            return URLComponents.marketUrl(path: [String(productNumber)], queryItems: nil)
        }
    }
}

class MarketURLSessionProvider {
    let session: URLSession = URLSession(configuration: .default)
    var market: Market?
    
    func fetchData<T: Decodable>(url: URL?, type: T.Type) {
        guard let url = url else { return }
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else { return }
            
            guard let decodedData = JSONDecoder.decodeFromSnakeCase(type: type,
                                                                    from: data) else { return }
            
            print(decodedData)
        }
        
        dataTask.resume()
    }
}
