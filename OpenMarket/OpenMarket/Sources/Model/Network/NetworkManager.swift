//
//  OpenMarket - NetworkManager.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import Foundation

struct NetworkManager {
    let session: URLSessionProtocol
    let hostUrlAddress: String = ProductsAPIEnum.hostUrl.address
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func getApplicationHealthChecker(completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        let targetAddress: String = hostUrlAddress + ProductsAPIEnum.healthChecker.address
        guard let targetURL: URL = URL(string: targetAddress) else {
            return
        }
        let targetRequest = makeRequest(url: targetURL, httpMethod: HttpMethodEnum.get)
        
        dataTask(request: targetRequest, completion: completion)
    }
    
    func getItemList(pageNumber: Int, itemPerPage: Int, searchValue: String? = nil, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        var searchValueString: String = String()
        if let unwrappingSearchValue: String = searchValue {
            searchValueString = ProductsAPIEnum.bridge.address + ProductsAPIEnum.searchValue.address + unwrappingSearchValue
        }
        let targetAddress: String = hostUrlAddress +
        ProductsAPIEnum.products.address +
        ProductsAPIEnum.pageNumber.address + String(pageNumber) +
        ProductsAPIEnum.bridge.address +
        ProductsAPIEnum.itemPerPage.address + String(itemPerPage) +
        searchValueString
        guard let targetURL: URL = URL(string: targetAddress) else {
            return
        }
        let targetRequest = makeRequest(url: targetURL, httpMethod: HttpMethodEnum.get)
        
        dataTask(request: targetRequest, completion: completion)
    }
    
    func getItemDetailList(productID: Int, completion: @escaping ((Result<Data, NetworkError>) -> Void)) {
        let targetAddress: String = hostUrlAddress + ProductsAPIEnum.products.address + String(productID)
        guard let targetURL: URL = URL(string: targetAddress) else {
            return
        }
        let targetRequest = makeRequest(url: targetURL, httpMethod: HttpMethodEnum.get)
        
        dataTask(request: targetRequest, completion: completion)
    }
    
    private func makeRequest(url: URL, httpMethod: HttpMethodEnum) -> URLRequest {
        var request: URLRequest = URLRequest(url: url,timeoutInterval: Double.infinity)
        
        request.httpMethod = httpMethod.name
        
        return request
    }
    
    private func dataTask(request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.dataTaskError))
            }
            
            if let serverResponse = response as? HTTPURLResponse {
                switch serverResponse.statusCode {
                case 100...101:
                    return completion(.failure(.informational))
                case 200...206:
                    break
                case 300...307:
                    return completion(.failure(.redirection))
                case 400...415:
                    return completion(.failure(.clientError))
                case 500...505:
                    return completion(.failure(.serverError))
                default:
                    return completion(.failure(.unknownError))
                }
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            return completion(.success(data))
        }
        
        task.resume()
    }
}
