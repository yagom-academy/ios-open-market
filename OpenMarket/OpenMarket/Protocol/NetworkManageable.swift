//
//  NetworkManageable.swift
//  OpenMarket
//
//  Created by James on 2021/06/01.
//

import Foundation

protocol NetworkManageable {
    var urlSession: URLSessionProtocol { get set }
}
extension NetworkManageable {
    func examineNetworkResponse(page: Int, completionHandler: @escaping (_ result: Result <HTTPURLResponse, APIError>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.connection.pathForItemList)\(page)") else {
            return completionHandler(.failure(APIError.network))
            
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(APIError.network))
                print(dataError.localizedDescription)
            }
            guard let urlResponse = response as? HTTPURLResponse,
                  urlResponse.statusCode == 200 else {
                return completionHandler(.failure(APIError.network))
            }
            completionHandler(.success(urlResponse))
            
        }.resume()
    }
    
    func examineNetworkRequest(page: Int, completionHandler: @escaping (_ result: Result <URLRequest, APIError>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.connection.pathForItemList)\(page)") else {
            return completionHandler(.failure(APIError.network))
            
        }
        
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(APIError.network))
                print(dataError.localizedDescription)
            }
            guard let urlResponse = response as? HTTPURLResponse,
                  urlResponse.statusCode == 200 else {
                return completionHandler(.failure(APIError.network))
            }
            completionHandler(.success(urlRequest))
            
        }.resume()
    }
}
