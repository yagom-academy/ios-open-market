//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/06/02.
//

import Foundation

struct NetworkManager {
    
    private var page = 1
    
    func handleTaskWithRequest<T: Decodable>(httpRequest: URLRequest, completionHandler: @escaping (Result<T, APIError>) -> ()) {
        
        let task = URLSession.shared.dataTask(with: httpRequest) { result in
            switch result {
            case .success(let data):
                // 호출하는 쪽에서 사용하게 재설정
                let decodedData = try? JSONDecoder().decode(T.self, from: data)
                if let decodedData = decodedData {
                    completionHandler(.success(decodedData))
                } else {
                    completionHandler(.failure(APIError.JSONParseError))
                }
            case .failure(let error):
                completionHandler(.failure(APIError.NetworkFailure(error)))
            }
        }
        task.resume()
    }
    
    func makeRequest(apiURL: String, httpBodyData: Data?, requestDataType: String, requestHeaderField: String) throws -> URLRequest {
        
        guard let apiURL = URL(string: apiURL) else {
            throw APIError.InvalidAddressError
        }
        
        var request = URLRequest(url: apiURL)
        request.httpMethod = HTTPMethod.post.description
        request.httpBody = httpBodyData
        request.setValue(requestDataType, forHTTPHeaderField: requestHeaderField)
        
        return request
    }
    
    func fetchItemList(completion: @escaping (Result<ItemList, APIError>) -> ()) {
        let fetchItemListURL = OpenMarketAPIPath.itemListSearch.path + "\(self.page)"
        
        guard let apiURL = URL(string: fetchItemListURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }

        let request = URLRequest(url:apiURL)
        
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
    }
    
    func fetchItem(completion: @escaping (Result<Item, APIError>) -> ()) {
        let fetchItemURL = OpenMarketAPIPath.itemSearch.path
        
        guard let apiURL = URL(string: fetchItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }

        let request = URLRequest(url:apiURL)
        
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
        
    }
    
    func registerItem(data: POSTRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) throws {
        let postItemURL = OpenMarketAPIPath.itemRegister.path
        let encodedJSONData = try? JSONEncoder().encode(data)
        if let request = try? makeRequest(apiURL: postItemURL, httpBodyData: encodedJSONData, requestDataType: StringContainer.RequestFormDataType.description, requestHeaderField: StringContainer.RequestContentTypeHeaderField.description){
            handleTaskWithRequest(httpRequest: request, completionHandler: completion)
        } else {
            throw APIError.NotFound404Error
        }
    }
    
    func deleteItem(data: DELETERequestItem, completion: @escaping (Result<Item, APIError>) -> ()) throws {
        let deleteItemURL = OpenMarketAPIPath.itemDeletion.path
        let encodedJSONData = try? JSONEncoder().encode(data)
        if let request = try? makeRequest(apiURL: deleteItemURL, httpBodyData: encodedJSONData, requestDataType: StringContainer.RequestFormDataType.description, requestHeaderField: StringContainer.RequestContentTypeHeaderField.description){
            handleTaskWithRequest(httpRequest: request, completionHandler: completion)
        } else {
            throw APIError.NotFound404Error
        }
    }
    
    func editItem(data: PATCHRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) throws {
        let editItemURL = OpenMarketAPIPath.itemEdit.path
        let encodedJSONData = try? JSONEncoder().encode(data)
        if let request = try? makeRequest(apiURL: editItemURL, httpBodyData: encodedJSONData, requestDataType: StringContainer.RequestFormDataType.description, requestHeaderField: StringContainer.RequestContentTypeHeaderField.description){
            handleTaskWithRequest(httpRequest: request, completionHandler: completion)
        } else {
            throw APIError.NotFound404Error
        }
    }
}

//MARK: - Customize URLSession
extension URLSession {
    func dataTask(
        with url: URL,
        handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: url) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else if let data = data {
                handler(.success(data))
            }
        }
    }
    
    func dataTask(
        with request: URLRequest,
        handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: request) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else if let data = data {
                handler(.success(data))
            }
        }
    }
}
