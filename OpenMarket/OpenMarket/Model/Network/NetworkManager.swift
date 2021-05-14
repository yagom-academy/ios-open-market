//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 배은서 on 2021/05/11.
//

import Foundation

struct NetworkManager {
    
    let session = URLSession.shared
    
    func dataTask(_ urlRequest: URLRequest, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.requestFailure))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completionHandler(.failure(.downcastingFailure("HTTPURLResponse")))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completionHandler(.failure(.networkFailure(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }.resume()
    }
    
    func request<Decoded: Decodable>(_ type: Decoded.Type, url: URL?, completionHandler: @escaping (Result<Decoded, APIError>) -> Void) {
        guard let requestURL = url else { return }
        
        let request = URLRequest.set(url: requestURL, httpMethod: .get)
        
        dataTask(request) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(type.self, from: data) else {
                    completionHandler(.failure(.decodingFailure))
                    return
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
    }
    
    func deleteItem(url: URL?, body: ItemForDelete, completionHandler: @escaping (Result<ItemResponse, APIError>) -> Void) {
        guard let requestURL = url else { return }
        
        var request = URLRequest.set(url: requestURL, httpMethod: .delete)
        guard let body = try? JSONEncoder().encode(body) else { return }
        request.httpBody = body
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        dataTask(request) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(ItemResponse.self, from: data) else {
                    completionHandler(.failure(.decodingFailure))
                    return
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func createBody(parameters: [String: Any], boundary: String) -> Data {
        var body = Data()
        
        for (key, value) in parameters {
            if let value = value as? [Data] {
                body.append(convertFormData(name: key, images: value, boundary: boundary))
            } else {
                body.append(convertFormData(name: key, value: value, boundary: boundary))
            }
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    func convertFormData(name: String, value: Any, boundary: String) -> Data {
        var data = Data()
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
        data.append("\(value)\r\n".data(using: .utf8)!)
        
        return data
    }
    
    func convertFormData(name: String, images: [Data], boundary: String) -> Data {
        var data = Data()
        var imageIndex = 0
        
        for image in images {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"aaa.png\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            data.append(image)
            data.append("\r\n".data(using: .utf8)!)
            //data.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
            imageIndex += 1
        }
        
        return data
    }
    
    
    func editItem(url: URL?, body: ItemForEdit, completionHandler: @escaping (Result<ItemResponse, APIError>) -> Void) {
        let boundary = generateBoundaryString()
        guard let requestURL = url else { return }
        guard let body: [String: Any] = body.asDictionary() else { return }
        let bodyData = createBody(parameters: body, boundary: boundary)
        
        var request = URLRequest.set(url: requestURL, httpMethod: .patch)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        print(bodyData)
        
        dataTask(request) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(ItemResponse.self, from: data) else {
                    completionHandler(.failure(.decodingFailure))
                    return
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
            
        }
    }
    
    func registerItem(url: URL?, body: ItemForRegistration, completionHandler: @escaping (Result<ItemResponse, APIError>) -> Void) {
        let boundary = generateBoundaryString()
        guard let requestURL = url else { return }
        guard let body: [String: Any] = body.asDictionary() else { return }
        let bodyData = createBody(parameters: body, boundary: boundary)
        
        var request = URLRequest.set(url: requestURL, httpMethod: .post)
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = bodyData
        
        print(bodyData)
        
        dataTask(request) { result in
            switch result {
            case .success(let data):
                guard let decodedData = try? JSONDecoder().decode(ItemResponse.self, from: data) else {
                    completionHandler(.failure(.decodingFailure))
                    return
                }
                completionHandler(.success(decodedData))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
}

extension Encodable {
  func asDictionary() -> [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else {
        print(APIError.encodingFailure)
        return nil
    }
    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
        print(APIError.dictionaryConversionFailure)
        return nil
    }
    
    return dictionary
  }
}



enum HTTPMethod {
    //    static let get = "GET"
    //    static let post = "POST"
    //    static let put = "PUT"
    //    static let patch = "PATCH"
    //    static let delete = "DELETE"
    case get, post, put, patch, delete
    
    var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .patch:
            return "PATCH"
        case .delete:
            return "DELETE"
        }
    }
}

extension URLRequest {
    static func set(url: URL, httpMethod: HTTPMethod) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = httpMethod.description
        
        return urlRequest
    }
}
