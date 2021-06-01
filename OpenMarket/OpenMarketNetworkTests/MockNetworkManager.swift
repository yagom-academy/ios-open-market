//
//  MockNetworkManager.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/06/01.
//

import Foundation
@testable import OpenMarket
final class MockNetworkManager {
    private var urlSession: URLSessionProtocol
    
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func getItemList(page: Int, completionHandler: @escaping (_ result: Result <HTTPURLResponse, APIError>) -> Void) {
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
}
