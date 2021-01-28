//
//  OenMarketAPI.swift
//  OpenMarket
//
//  Created by sole on 2021/01/26.
//

import Foundation

enum OpenMarketAPIError: Error {
    case dataDecodingError
    case clientSideError
    case serverSideError
    case noData
    case noResponse
    case wrongURL
    case unknown
}

class OpenMarketAPI {
    
    private static var session = URLSession(configuration: .default)
    private static var ephemeralSession = URLSession(configuration: .ephemeral)
    
    static func getItemList(page: Int, _ completionHandler: @escaping (Result<ItemsToGet, Error>) -> Void) {
        guard let url = URLManager.makeURL(type: .getItemList, value: page) else {
            completionHandler(.failure(OpenMarketAPIError.wrongURL))
            return
        }
    
        session.dataTask(with: url) { (data, response, error) in
            let result = getResult(ItemsToGet.self, data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
    
    static func getItem(id: Int, _ completionHandler: @escaping (Result<ItemToGet, Error>) -> Void) {
        guard let url = URLManager.makeURL(type: .getItem, value: id) else {
            completionHandler(.failure(OpenMarketAPIError.wrongURL))
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            let result = getResult(ItemToGet.self, data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
    
    static func postItem(itemToPost: ItemToPost, _ completionHandler: @escaping(Result<ItemAfterPost, Error>) -> Void) {
        guard let url = URLManager.makeURL(type: .postItem, value: nil) else {
            completionHandler(.failure(OpenMarketAPIError.wrongURL))
            return
        }
        // TODO: URLRequest 부분 따로 구현.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let dataToPost = Parser.encodeData(itemToPost) else {
            print("Encoding Error")
            return
        }
        ephemeralSession.uploadTask(with: urlRequest, from: dataToPost) { (data, response, error) in
            let result = getResult(ItemAfterPost.self, data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
    
    static func patchItem(id: Int, itemToPatch: ItemToPatch, _ completionHandler: @escaping(Result<ItemAfterPatch, Error>) -> Void) {
        guard let url = URLManager.makeURL(type: .patchItem, value: id) else {
            completionHandler(.failure(OpenMarketAPIError.wrongURL))
            return
        }
        // TODO: URLRequest 부분 따로 구현.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let dataToPatch = Parser.encodeData(itemToPatch) else {
            print("Encoding Error")
            return
        }
        ephemeralSession.uploadTask(with: urlRequest, from: dataToPatch) { (data, response, error) in
            let result = getResult(ItemAfterPatch.self, data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
    
    static func deleteItem(id: Int, itemToDelete: ItemToDelete, _ completionHandler: @escaping(Result<ItemAfterDelete, Error>) -> Void) {
        guard let url = URLManager.makeURL(type: .deleteItem, value: id) else {
            completionHandler(.failure(OpenMarketAPIError.wrongURL))
            return
        }
        // TODO: URLRequest 부분 따로 구현.
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let dataToDelete = Parser.encodeData(itemToDelete) else {
            print("Encoding Error")
            return
        }
        ephemeralSession.uploadTask(with: urlRequest, from: dataToDelete) { (data, response, error) in
            let result = getResult(ItemAfterDelete.self, data: data, response: response, error: error)
            completionHandler(result)
        }.resume()
    }
    
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
