//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/06/02.
//

import Foundation

struct NetworkManager {
    
    private var page = 1
    
    func getJSONDataFromResponse<T: Decodable>(url: String, completionHandler: @escaping (Result<T, APIError>) -> () ) {
        guard let apiURI = URL(string: url) else {
            completionHandler(.failure(APIError.InvalidAddressError))
            return
        }
        
        let task = URLSession.shared.dataTask(with: apiURI) { result in
            switch result {
            case .success(let data):
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
    
    func handleTaskWithRequest<T: Decodable>(httpRequest: URLRequest, completionHandler: @escaping (Result<T, APIError>) -> ()) {
        
        let task = URLSession.shared.dataTask(with: httpRequest) { result in
            switch result {
            case .success(let data):
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
    
    func fetchItemList(completion: @escaping (Result<ItemList, APIError>) -> ()) {
        let fetchItemListURL = OpenMarketAPIPath.itemListSearch.path + "\(self.page)"
        
        guard let apiURI = URL(string: fetchItemListURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }

        getJSONDataFromResponse(url: fetchItemListURL, completionHandler: completion)
    }
    
    func fetchItem(completion: @escaping (Result<Item, APIError>) -> ()) {
        let fetchItemURL = OpenMarketAPIPath.itemSearch.path
        getJSONDataFromResponse(url: fetchItemURL, completionHandler: completion)
    }
    
    func registerItem(data: POSTRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let postItemURL = OpenMarketAPIPath.itemRegister.path
        
        guard let apiURI = URL(string: postItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiURI)
        let encodedJSONData = try? JSONEncoder().encode(data)
        request.httpMethod = HTTPMethod.post.description
        request.httpBody = encodedJSONData
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
    }
    
    func deleteItem(data: DELETERequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let deleteItemURL = OpenMarketAPIPath.itemDeletion.path
        
        guard let apiURI = URL(string: deleteItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiURI)
        let encodedJSONData = try? JSONEncoder().encode(data)
        request.httpMethod = HTTPMethod.delete.description
        request.httpBody = encodedJSONData
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
    }
    
    func editItem(data: PATCHRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let editItemURL = OpenMarketAPIPath.itemEdit.path
        
        guard let apiURI = URL(string: editItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiURI)
        let encodedJSONData = try? JSONEncoder().encode(data)
        request.httpMethod = HTTPMethod.patch.description
        request.httpBody = encodedJSONData
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
    }
}

extension URLSession {
    func dataTask(
        with url: URL,
        handler: @escaping (Result<Data, Error>) -> Void
    ) -> URLSessionDataTask {
        dataTask(with: url) { data, _, error in
            if let error = error {
                handler(.failure(error))
            } else {
                handler(.success(data ?? Data()))
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
            } else {
                handler(.success(data ?? Data()))
            }
        }
    }
}
