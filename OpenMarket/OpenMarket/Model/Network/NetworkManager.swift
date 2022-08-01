//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/28.
//

import Foundation

class NetworkManager {
    private let session = URLSession.shared
    private var baseComponents = URLComponents(string: OpenMarketURL.baseURL.description)
    
    private func fetchData(request: URLRequest, completion: @escaping (Result<Data?, FetchError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(FetchError.failFetch))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.wrongResponse))
            }
            
            guard let responseBody = data else {
                return completion(.failure(.emptyData))
            }
            
            completion(.success(responseBody))
        }
        task.resume()
    }
    
    func fetchItmeList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<Data?, FetchError>) -> Void) {
        let firstQuery = URLQueryItem(name: OpenMarketURL.pageNumberQuery.description, value: "\(pageNumber)")
        let secondQuery = URLQueryItem(name: OpenMarketURL.itemsPerPageQuery.description, value: "\(itemsPerPage)")
        baseComponents?.queryItems = [firstQuery, secondQuery]
        
        guard let requestURL = baseComponents?.url else { return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.request
        
        fetchData(request: request, completion: completion)
    }
}
