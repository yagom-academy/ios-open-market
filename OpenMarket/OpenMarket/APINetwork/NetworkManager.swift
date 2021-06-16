//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/06/02.
//

import Foundation

struct NetworkManager {
    
    private func fetchModel<T: Decodable>(with urlRequest: URLRequest, completionHandler: @escaping (Result<T, APIError>) -> Void) {
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data else {
                return completionHandler(.failure(APIError.NotFound404Error))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completionHandler(.failure(APIError.NetworkFailure))
            }
            
            guard let model = try? JSONDecoder().decode(T.self, from: data) else {
                return completionHandler(.failure(APIError.JSONParseError))
            }
            
            completionHandler(.success(model))
        }.resume()
    }
    
    private func makeRequest(apiURL: String, httpBodyData: Data?, requestDataType: DataTypeFormat, requestHeaderField: RequestHeaderField) throws -> URLRequest {
        
        guard let apiURL = URL(string: apiURL) else {
            throw APIError.InvalidAddressError
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = HTTPMethod.post.description
        request.httpBody = httpBodyData
        request.setValue(requestDataType.description, forHTTPHeaderField: requestHeaderField.description)
        
        return request
    }
    
    func fetchItemList(page: UInt, completion: @escaping (Result<ItemList, APIError>) -> ()) {
        let fetchItemListURL = OpenMarketAPIPath.itemListSearch.path + "\(page)"
        
        guard let apiURL = URL(string: fetchItemListURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        let request = URLRequest(url: apiURL)
        fetchModel(with: request, completionHandler: completion)
    }
    
    func fetchItem(completion: @escaping (Result<Item, APIError>) -> ()) {
        let fetchItemURL = OpenMarketAPIPath.itemSearch.path
        
        guard let apiURL = URL(string: fetchItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        let request = URLRequest(url:apiURL)
        
        fetchModel(with: request, completionHandler: completion)
    }
    
    func registerItem(data: POSTRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let postItemURL = OpenMarketAPIPath.itemRegister.path
        let encodedJSONData = try? JSONEncoder().encode(data)
        if let request = try? makeRequest(apiURL: postItemURL, httpBodyData: encodedJSONData, requestDataType: .MultipartFormData, requestHeaderField: .ContentType) {
            fetchModel(with: request, completionHandler: completion)
        } else {
            completion(.failure(APIError.NotFound404Error))
        }
    }
    
    func deleteItem(data: DELETERequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let deleteItemURL = OpenMarketAPIPath.itemDeletion.path
        let encodedJSONData = try? JSONEncoder().encode(data)
        if let request = try? makeRequest(apiURL: deleteItemURL, httpBodyData: encodedJSONData, requestDataType: .MultipartFormData, requestHeaderField: .ContentType) {
            fetchModel(with: request, completionHandler: completion)
        } else {
            completion(.failure(APIError.NotFound404Error))
        }
    }
    
    func editItem(data: PATCHRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let editItemURL = OpenMarketAPIPath.itemEdit.path
        let encodedJSONData = try? JSONEncoder().encode(data)
        if let request = try? makeRequest(apiURL: editItemURL, httpBodyData: encodedJSONData, requestDataType: .MultipartFormData, requestHeaderField: .ContentType) {
            fetchModel(with: request, completionHandler: completion)
        } else {
            completion(.failure(APIError.NotFound404Error))
        }
    }
}
