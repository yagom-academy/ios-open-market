//
//  APIRequest.swift
//  OpenMarket
//
//  Created by NAMU on 2022/07/12.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch  = "PATCH"
}

enum URLHost {
    static let openMarket = "https://market-training.yagom-academy.kr"
}

enum URLAdditionalPath {
    static let healthChecker = "/healthChecker"
    static let product = "/api/products"
}

protocol APIRequest {
}

extension APIRequest {
    func requestData(pageNumber: Int,
                     itemPerPage: Int,
                     completion: @escaping (Result<ProductsDetailList, Error>) -> Void) {
        var urlComponets = URLComponents(string: URLHost.openMarket + URLAdditionalPath.product)
        let pageNumber = URLQueryItem(name: "page_no", value: "\(pageNumber)")
        let itemPerPage = URLQueryItem(name: "items_per_page", value: "\(itemPerPage)")
        urlComponets?.queryItems?.append(pageNumber)
        urlComponets?.queryItems?.append(itemPerPage)
        guard let url = urlComponets?.url else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(error ?? NetworkError.requestError))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 <= response.statusCode, response.statusCode < 300
            else {
                completion(.failure(NetworkError.requestError))
                return
            }
            
            guard let safeData = data else { return }
            guard let decodedData = try? JSONDecoder().decode(ProductsDetailList.self,
                                                              from: safeData)
            else {
                completion(.failure(CodableError.decodeError))
                return
            }
            completion(.success(decodedData))
        }
        task.resume()
    }
}
