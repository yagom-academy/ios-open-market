//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/12.
//

import Foundation

final class NetworkManager {
    private let session: URLSessionProtocol
    private let baseURL = "https://market-training.yagom-academy.kr/api/products"
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    private func loadData(request: URLRequest, completion: @escaping (Result<Data?, ResponseError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.defaultResponseError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.statusError))
            }
            
            guard let result = data else {
                return completion(.failure(.dataError))
            }
            
            completion(.success(result))
        }
        task.resume()
    }
    
    func getItemList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<Data?, ResponseError>) -> Void) {
        guard let url = URL(string: baseURL + URLPath.itemListPath(pageNumber: pageNumber, itemsPerPage: itemsPerPage).description) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.type
        
        loadData(request: request, completion: completion)
    }
    
    func getProduct(productId: Int, completion: @escaping (Result<Data?, ResponseError>) -> Void) {
        guard let url = URL(string: baseURL + URLPath.productPath(productId: productId).description) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get.type
        
        loadData(request: request, completion: completion)
    }
}
