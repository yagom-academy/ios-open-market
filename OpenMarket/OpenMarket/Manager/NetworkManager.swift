//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

enum Result<T, U> {
    case success(T)
    case failure(U)
}

final class NetworkManager {
    var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getItemList(node: APINode, page: Int, completionHandler: @escaping (_ result: Result <OpenMarketItemList, APIError>) -> Void) {
        guard let url = URL(string: "\(node.urlForItemList)\(page)") else {
            return completionHandler(.failure(APIError.decoding))
            
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
            guard let itemListData = data else {
                return completionHandler(.failure(APIError.network))
                
            }
            
            if let itemList = try? JSONDecoder().decode(OpenMarketItemList.self, from: itemListData) {
                completionHandler(.success(itemList))
            } else {
                completionHandler(.failure(APIError.decoding))
            }
            
        }.resume()
    }
}
