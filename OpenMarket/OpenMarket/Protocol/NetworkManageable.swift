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
    func examineNetworkResponse(page: Int, completionHandler: @escaping (_ result: Result <HTTPURLResponse, Error>) -> Void) {
        guard let url = URL(string: "\(OpenMarketAPI.connection.pathForItemList)\(page)") else {
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
                    completionHandler(.success(urlResponse))
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
