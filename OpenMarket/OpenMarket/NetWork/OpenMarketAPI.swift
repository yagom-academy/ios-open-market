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
    
    static func getItemList(page: Int, _ completionHandler: @escaping (ItemsToGet) -> Void) {
        guard let url = URLManager.makeURL(type: .getItemList, value: page) else {
            print("URL Error")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let successRange =  200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Status Code Error")
                return
            }
            
            guard let data = data else {
                print("No Data Error")
                return
            }
     
            guard let items = Parser.decodeData(ItemsToGet.self, data) else {
                print("Data Decoding Error")
                return
            }
            
            completionHandler(items)
        }.resume()
    }
    
    static func getItem(id: Int, _ completionHandler: @escaping (ItemToGet) -> Void) {
        guard let url = URLManager.makeURL(type: .getItem, value: id) else {
            print("URL Error")
            return
        }
        
        session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let successRange =  200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Status Code Error")
                return
            }
            
            guard let data = data else {
                print("No Data Error")
                return
            }
     
            guard let item = Parser.decodeData(ItemToGet.self, data) else {
                print("Data Decoding Error")
                return
            }
            
            completionHandler(item)
        }.resume()
    }
    
    static func postItem(itemToPost: ItemToPost, _ completionHandler: @escaping(ItemAfterPost) -> Void) {
        guard let url = URLManager.makeURL(type: .postItem, value: nil) else {
            print("URL Error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let dataToPost = Parser.encodeData(itemToPost) else {
            print("Encoding Error")
            return
        }
        ephemeralSession.uploadTask(with: urlRequest, from: dataToPost) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let successRange =  200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Status Code Error")
                return
            }
            
            guard let data = data else {
                print("No Data Error")
                return
            }
            
            guard let item = Parser.decodeData(ItemAfterPost.self, data) else {
                print("Data Decoding Error")
                return
            }
            completionHandler(item)
        }.resume()
    }
    
    static func patchItem(id: Int, itemToPatch: ItemToPatch, _ completionHandler: @escaping(ItemAfterPatch) -> Void) {
        guard let url = URLManager.makeURL(type: .patchItem, value: id) else {
            print("URL Error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let dataToPatch = Parser.encodeData(itemToPatch) else {
            print("Encoding Error")
            return
        }
        ephemeralSession.uploadTask(with: urlRequest, from: dataToPatch) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let successRange =  200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Status Code Error")
                return
            }
            
            guard let data = data else {
                print("No Data Error")
                return
            }
            
            guard let item = Parser.decodeData(ItemAfterPost.self, data) else {
                print("Data Decoding Error")
                return
            }
            completionHandler(item)
        }.resume()
    }
    
    static func deleteItem(id: Int, itemToDelete: ItemToDelete, _ completionHandler: @escaping(ItemAfterDelete) -> Void) {
        guard let url = URLManager.makeURL(type: .deleteItem, value: id) else {
            print("URL Error")
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        guard let dataToDelete = Parser.encodeData(itemToDelete) else {
            print("Encoding Error")
            return
        }
        
        ephemeralSession.uploadTask(with: urlRequest, from: dataToDelete) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            let successRange =  200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else {
                print("Status Code Error")
                return
            }
            
            guard let data = data else {
                print("No Data Error")
                return
            }
            
            guard let item = Parser.decodeData(ItemAfterDelete.self, data) else {
                print("Data Decoding Error")
                return
            }
            
            completionHandler(item)
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
}
