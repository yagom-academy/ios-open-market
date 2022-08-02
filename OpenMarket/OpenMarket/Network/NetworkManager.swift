//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import UIKit

final class NetworkManager {
    private let session: URLSessionProtocol
    private let identifier = NetworkNamespace.identifier.name
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetch(request: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let dataTask: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(NetworkError.outOfRange))
            }
            
            guard let data = data else {
                return completion(.failure(NetworkError.noneData))
            }
            completion(.success(data))
        }
        dataTask.resume()
    }
    
    func getProductInquiry(request: URLRequest?,
                           completion: @escaping (Result<Data, Error>) -> Void) {
        let baseURL = URL(string: NetworkNamespace.url.name)
        guard let url = baseURL else { return }
        
        var request = request ?? URLRequest(url: url)
        request.httpMethod = NetworkNamespace.get.name
        
        fetch(request: request, completion: completion)
    }

    func postProduct(params: [String: Any?], images: [UIImage], completion: @escaping (Result<Data, Error>) -> Void) {
        let passwordKey = NetworkNamespace.passwordKey.name
        let passwordValue = NetworkNamespace.passwordValue.name
        var newParms = params
        
        newParms[passwordKey] = passwordValue

        guard var request = OpenMarketRequest().createPostRequest(identifier: identifier) else { return }

        let postData = OpenMarketRequest().createPostBody(parms: newParms as [String: Any], images: images)

        request.httpBody = postData

        fetch(request: request) { result in
            switch result {
            case .success(let data):
                return completion(.success(data))
            case .failure(let error):
                return completion(.failure(error))
            }
        }
    }
    
    func postSecret(productId: String, password: String) {
        let components = URLComponents(string: NetworkNamespace.url.name)

        guard var url = components?.url else { return }

        url.appendPathComponent(productId)
        url.appendPathComponent(Request.secret)

        var request = URLRequest(url: url, timeoutInterval: Double.infinity)

        request.httpMethod = NetworkNamespace.post.name
        request.addValue(identifier, forHTTPHeaderField: Request.identifier)
        request.addValue(Multipart.jsonContentType, forHTTPHeaderField: Multipart.contentType)
        
        let parameters = "{\"\(Request.secret)\": \"\(password)\"}"
        let postData = parameters.data(using: .utf8)

        request.httpBody = postData
            fetch(request: request) { result in
                switch result {
                case .success(let data):
                    self.deleteProduct(productId: productId, productSecretId: data)
                case .failure(let error):
                    print(error)
                }
            }
        
    }

    func patchProduct(productId: String) {
        guard var request = OpenMarketRequest().requestProductDetail(of: productId) else { return }
        
        request.httpMethod = NetworkNamespace.patch.name
        request.addValue(identifier, forHTTPHeaderField: Request.identifier)
        
        let params: [String: Any] = ["name": "아야나", "descriptions": "테스트중임", "price": 222, "currency": Currency.KRW.rawValue, "secret": "lP8VFiBqGI"]
        
        guard let jsonData = OpenMarketRequest().createJson(params: params) else { return }
        request.httpBody = jsonData
        
        fetch(request: request) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func deleteProduct(productId: String, productSecretId: Data) {
        guard let secret = String(data: productSecretId, encoding: .utf8) else { return }
        let components = URLComponents(string: NetworkNamespace.url.name)
        
        guard var url = components?.url else { return }
        
        url.appendPathComponent(productId)
        url.appendPathComponent(secret)
        
        var request = URLRequest(url: url)

        request.httpMethod = NetworkNamespace.del.name
        request.addValue(identifier, forHTTPHeaderField: Request.identifier)
        
        fetch(request: request) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}
