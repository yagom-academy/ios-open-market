//
//  Networking.swift
//  OpenMarket
//
//  Created by sole on 2021/02/01.
//

import Foundation

struct Network {
    
    static func getResponseError(_ response: URLResponse?) -> Error? {
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            return OpenMarketAPIError.noResponse
        }
        switch statusCode {
        case 200..<300:
            return nil
        case 300..<400:
            return OpenMarketAPIError.clientSideError
        case 400..<500:
            return OpenMarketAPIError.serverSideError
        default:
            return OpenMarketAPIError.unknown
        }
    }
    
    static func getResult<T: Decodable>(_ type: T.Type, data: Data?, response: URLResponse?, error: Error?) -> Result<T, Error> {
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
 
        guard let items = Parser.decodeData(type, data) else {
            return .failure(OpenMarketAPIError.dataDecodingError)
        }
        
        return .success(items)
    }
}
