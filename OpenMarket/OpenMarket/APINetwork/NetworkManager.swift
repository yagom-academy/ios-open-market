//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/06/02.
//

import Foundation

struct NetworkManager {
    
    private var page = 1
    
    func getJSONDataFromResponse<T: Decodable>(url: String, completionHandler: @escaping (T?) -> () ) throws {
        guard let apiURI = URL(string: url) else { throw APIError.InvalidAddressError }
        
        let task = URLSession.shared.dataTask(with: apiURI) { data, response, error in
            guard let data = data else { return }
            let decodedData = try? JSONDecoder().decode(T.self, from: data)
            completionHandler(decodedData)
        }
        task.resume()
    }
    
    func sendFormDataWithRequest<T: Encodable>(data: T, HTTPMethod: HTTPMethod, url: String, completionHandler: @escaping (Data?) -> ()) throws {
        guard let apiURI = URL(string: url) else { throw APIError.InvalidAddressError }
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiURI)
        request.httpMethod = HTTPMethod.description
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let encodedJSONData = try? JSONEncoder().encode(data)
            completionHandler(encodedJSONData)
        }
        task.resume()
    }
    
    func fetchItemList(completion: @escaping (GETResponseItemList?) -> ()) throws {
        
        let fetchItemListURL = OpenMarketAPIPath.itemListSearch.path + "\(self.page)"
        do {
            try getJSONDataFromResponse(url: fetchItemListURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func fetchItem(completion: @escaping (GETResponseItem?) -> ()) throws {
        
        let fetchItemURL = OpenMarketAPIPath.itemSearch.path
        
        do {
            try getJSONDataFromResponse(url: fetchItemURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func registerItem(registerItem: POSTRequestItem, completion: @escaping (Data?) -> ()) throws {
        let postItemURL = OpenMarketAPIPath.itemRegister.path
        do {
            try sendFormDataWithRequest(data: registerItem, HTTPMethod: HTTPMethod.post, url: postItemURL, completionHandler: completion)
        } catch {
            throw APIError.JSONParseError
        }
        
        do {
            try getJSONDataFromResponse(url: postItemURL, completionHandler: completion)
        } catch {
            throw APIError.JSONParseError
        }
    }
}
