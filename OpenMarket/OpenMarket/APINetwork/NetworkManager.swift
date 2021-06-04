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
    
    func sendFormDataWithRequest<SendType: Encodable, FetchType: Decodable>(data: SendType, HTTPMethod: HTTPMethod, url: String, completionHandler: @escaping (FetchType?) -> ()) throws {
        guard let apiURI = URL(string: url) else { throw APIError.InvalidAddressError }
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiURI)
        let encodedJSONData = try? JSONEncoder().encode(data) // Data로 반환
        request.httpMethod = HTTPMethod.description
        request.httpBody = encodedJSONData
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else { return }
            let decodedData = try? JSONDecoder().decode(FetchType.self, from: data)
            completionHandler(decodedData)
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
    
    func registerItem(registerItem: POSTRequestItem, completion: @escaping (POSTResponseItem?) -> ()) throws {
        let postItemURL = OpenMarketAPIPath.itemRegister.path
        do {
            try sendFormDataWithRequest(data: registerItem, HTTPMethod: HTTPMethod.post, url: postItemURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func deleteItem(deleteItem: DELETERequestItem, completion: @escaping (DELETEResponseItem?) -> ()) throws {
        let deleteItemURL = OpenMarketAPIPath.itemDeletion.path
        do {
            try sendFormDataWithRequest(data: deleteItem, HTTPMethod: HTTPMethod.delete, url: deleteItemURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func editItemInformation(editItem: PATCHRequestItem, completion: @escaping (PATCHResponseItem?) -> ()) throws {
        let editItemInformationURL = OpenMarketAPIPath.itemEdit.path
        do {
            try sendFormDataWithRequest(data: editItem, HTTPMethod: HTTPMethod.patch, url: editItemInformationURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
}
