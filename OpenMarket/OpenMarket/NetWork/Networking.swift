//
//  Networking.swift
//  OpenMarket
//
//  Created by sole on 2021/02/01.
//

import Foundation

struct Network {
    private static func getResponseError(_ response: URLResponse?) -> Error? {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return OpenMarketAPIError.noResponse
        }
        switch statusCode {
        case 200..<300:
            return nil
        case 300..<400:
            return OpenMarketAPIError.redirectionMessage
        case 400..<500:
            return OpenMarketAPIError.clientSideErrorResponse
        case 500..<600:
            return OpenMarketAPIError.serverSideErrorResponse
        default:
            return OpenMarketAPIError.unknown
        }
    }
    
    private static func getResult(data: Data?, response: URLResponse?, error: Error?) -> Result<Data, Error> {
        if let error = error {
            print(error.localizedDescription)
            return .failure(error)
        }

        if let responseError = getResponseError(response) {
            return .failure(responseError)
        }
        
        guard let data = data else {
            return .failure(OpenMarketAPIError.noData)
        }
        
        return .success(data)
    }
    
    static func sendRequest(_ request: URLRequest, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result = Network.getResult(data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
}
