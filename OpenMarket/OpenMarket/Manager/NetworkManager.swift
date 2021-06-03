//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by James on 2021/05/31.
//

import Foundation

final class NetworkManager: NetworkManageable {
    var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getItemList(page: Int, completionHandler: @escaping (_ result: Result <OpenMarketItemList, Error>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.connection.urlForItemList)\(page)") else {
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
                let urlResponseError = self.handleNetworkResponseError(urlResponse)
                switch urlResponseError {
                case .failure(let networkError):
                    completionHandler(.failure(networkError))
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
    
    func handleNetworkResponseError(_ response: HTTPURLResponse) -> NetworkResponseResult<Error> {
        switch response.statusCode {
        case 200...299:
            return .success
        case 401...500:
            return .failure(NetworkResponseError.authenticationError)
        case 501...599:
            return .failure(NetworkResponseError.badRequest)
        case 600:
            return .failure(NetworkResponseError.outdated)
        default:
            return .failure(NetworkResponseError.failed)
        }
    }
}
