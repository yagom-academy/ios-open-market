//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/15.
//

import Foundation

enum Request {
    case healthChecker
    case productList(number: Int)
    case productDetail(number: Int)
    
    var name: String {
        switch self {
        case .healthChecker:
            return "/healthChecker"
        case .productList(let number):
            return "/api/products?page_no=\(number)&items_per_page=100"
        case .productDetail(let number):
            return "/api/products/\(number)"
        }
    }
}

class MarketURLSessionProvider {
    let session: URLSession = URLSession(configuration: .default)
    let baseUrl: URL? = URL(string: "https://openmarket.yagom-academy.kr")
    var market: Market?
    
    func fetchData<T: Decodable>(request: Request, type: T.Type) {
        guard let baseUrl = baseUrl,
              let relativeUrl = URL(string: request.name, relativeTo: baseUrl) else { return }
        
        let dataTask = session.dataTask(with: relativeUrl) { (data, response, error) in
            guard error == nil,
                  let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let data = data else {
                return }
            
            guard let decodedData = JSONDecoder.decodeFromServer(type: type,
                                                                 from: data) else { return }
            print(decodedData)
        }
        
        dataTask.resume()
    }
}
