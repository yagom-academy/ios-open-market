//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

final class NetworkManager: NetworkManageable {
    let urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getItemList(page: Int, completionHandler: @escaping (_ result: Result <OpenMarketItemList, Error>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.urlForItemList)\(page)") else {
            return completionHandler(.failure(NetworkResponseError.badRequest))
        }
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = HTTPMethods.get.rawValue
        
        urlSession.dataTask(with: urlRequest) { data, response, error in
            if let dataError = error {
                completionHandler(.failure(NetworkResponseError.noData))
                print(dataError.localizedDescription)
            }
            if let urlResponse = response as? HTTPURLResponse {
                let urlResponseResult = self.handleNetworkResponseError(urlResponse)
                switch urlResponseResult {
                case .failure(let errorDescription):
                    print(errorDescription)
                    return completionHandler(.failure(NetworkResponseError.badRequest))
                case .success:
                    guard let itemListData = data else {
                        return completionHandler(.failure(NetworkResponseError.noData))
                    }
                    if let itemList = try? JSONDecoder().decode(OpenMarketItemList.self, from: itemListData) {
                        completionHandler(.success(itemList))
                    } else {
                        completionHandler(.failure(DataError.decoding))
                    }
                }
            }
        }.resume()
    }
}
