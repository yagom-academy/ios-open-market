//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Kiwi, Hugh on 2022/07/12.
//

import Foundation

final class NetworkManager {
    private let session: URLSessionProtocol
    private let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    private func loadData(request: URLRequest, completion: @escaping (Result<Data?, ResponseError>) -> Void) {
        let task = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return completion(.failure(.defaultError))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.statusError))
            }
            
            guard let safeData = data else {
                return completion(.failure(.dataError))
            }
            
            completion(.success(safeData))
        }
        task.resume()
    }
    
    func getMethod(pageNumber: Int? = nil, itemsPerPage: Int? = nil, productId: Int? = nil, completion: @escaping (Result<Data?, ResponseError>) -> Void) {
        var safeURL: URL
        
        if productId == nil {
            guard let pageNumber = pageNumber,
                  let itemsPerPage = itemsPerPage,
                  let url = URL(string: baseURL + "api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)") else { return }
            
            safeURL = url
        } else {
            guard let productId = productId,
                  let url = URL(string: baseURL + "api/products/\(productId)") else { return }
            
            safeURL = url
        }
        
        var request = URLRequest(url: safeURL)
        request.httpMethod = RequestType.get.method
        
        loadData(request: request, completion: completion)
    }
}
