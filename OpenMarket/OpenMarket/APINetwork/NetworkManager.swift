//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Seungjin Baek on 2021/06/02.
//

import Foundation

struct NetworkManager {
    
    private var page = 1
    
    func getJSONDataFromResponse<T: Decodable>(url: String, completionHandler: @escaping (Result<T, APIError>) -> () ) throws {
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
    
    func sendFormDataWithRequest<SendType: Encodable, FetchType: Decodable>(data: SendType, HTTPMethod: HTTPMethod, url: String, completionHandler: @escaping (Result<FetchType, APIError>) -> ()) throws {
        guard let apiURI = URL(string: url) else {
            completionHandler(.failure(APIError.InvalidAddressError))
            return
        }
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: apiURI)
        let encodedJSONData = try? JSONEncoder().encode(data)
        request.httpMethod = HTTPMethod.description
        request.httpBody = encodedJSONData
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { result in
            switch result {
            case .success(let data):
                let decodedData = try? JSONDecoder().decode(FetchType.self, from: data)
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
    
    func fetchItemList(completion: @escaping (Result<GETResponseItemList, APIError>) -> ()) throws {
        
        let fetchItemListURL = OpenMarketAPIPath.itemListSearch.path + "\(self.page)"
        do {
            try getJSONDataFromResponse(url: fetchItemListURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func fetchItem(completion: @escaping (Result<GETResponseItem, APIError>) -> ()) throws {
        
        let fetchItemURL = OpenMarketAPIPath.itemSearch.path
        
        do {
            try getJSONDataFromResponse(url: fetchItemURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func registerItem(registerItem: POSTRequestItem, completion: @escaping (Result<POSTResponseItem, APIError>) -> ()) throws {
        let postItemURL = OpenMarketAPIPath.itemRegister.path
        do {
            try sendFormDataWithRequest(data: registerItem, HTTPMethod: HTTPMethod.post, url: postItemURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func deleteItem(deleteItem: DELETERequestItem, completion: @escaping (Result<DELETEResponseItem, APIError>) -> ()) throws {
        let deleteItemURL = OpenMarketAPIPath.itemDeletion.path
        do {
            try sendFormDataWithRequest(data: deleteItem, HTTPMethod: HTTPMethod.delete, url: deleteItemURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
    }
    
    func editItemInformation(editItem: PATCHRequestItem, completion: @escaping (Result<PATCHResponseItem, APIError>) -> ()) throws {
        let editItemInformationURL = OpenMarketAPIPath.itemEdit.path
        do {
            try sendFormDataWithRequest(data: editItem, HTTPMethod: HTTPMethod.patch, url: editItemInformationURL, completionHandler: completion)
        } catch {
            throw APIError.NotFound404Error
        }
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
