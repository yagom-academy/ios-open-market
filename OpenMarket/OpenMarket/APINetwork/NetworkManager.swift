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
    
    func addInformationOnRequest(request: inout URLRequest, httpBodyData: Data?, requestDataType: String, requestHeaderField: String) {
        request.httpMethod = HTTPMethod.post.description
        request.httpBody = httpBodyData
        request.setValue(requestDataType, forHTTPHeaderField: requestHeaderField)
    }
    
    func registerItem(data: POSTRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let postItemURL = OpenMarketAPIPath.itemRegister.path
        
        guard let apiURL = URL(string: postItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        var request = URLRequest(url: apiURL)
        let encodedJSONData = try? JSONEncoder().encode(data)
        addInformationOnRequest(request: &request, httpBodyData: encodedJSONData, requestDataType: StringContainer.RequestFormDataType.description, requestHeaderField: StringContainer.RequestContentTypeHeaderField.description)
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
    }
    
    func deleteItem(data: DELETERequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let deleteItemURL = OpenMarketAPIPath.itemDeletion.path
        
        guard let apiURL = URL(string: deleteItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        var request = URLRequest(url: apiURL)
        let encodedJSONData = try? JSONEncoder().encode(data)
        
        addInformationOnRequest(request: &request, httpBodyData: encodedJSONData, requestDataType: StringContainer.RequestFormDataType.description, requestHeaderField: StringContainer.RequestContentTypeHeaderField.description)
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
    }
    
    func editItem(data: PATCHRequestItem, completion: @escaping (Result<Item, APIError>) -> ()) {
        let editItemURL = OpenMarketAPIPath.itemEdit.path
        
        guard let apiURL = URL(string: editItemURL) else {
            completion(.failure(APIError.InvalidAddressError))
            return
        }
        
        var request = URLRequest(url: apiURL)
        let encodedJSONData = try? JSONEncoder().encode(data)
        
        addInformationOnRequest(request: &request, httpBodyData: encodedJSONData, requestDataType: StringContainer.RequestFormDataType.description, requestHeaderField: StringContainer.RequestContentTypeHeaderField.description)
        handleTaskWithRequest(httpRequest: request, completionHandler: completion)
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
