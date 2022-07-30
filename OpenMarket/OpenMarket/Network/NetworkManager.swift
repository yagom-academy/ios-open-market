//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import UIKit

final class NetworkManager {
    private let session: URLSessionProtocol
    
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
                print(response?.description)
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

    func postProduct() {
        let identifier = "d1fb22fc-0335-11ed-9676-3bb3eb48793a"

        guard var request = OpenMarketRequest().createPostRequest(identifier: identifier) else { return }

        let params: [String: Any] = ["name": "테스트중", "descriptions": "테스트중임", "price": 222, "currency": Currency.KRW.rawValue, "secret": "lP8VFiBqGI"]
        let postData = OpenMarketRequest().createPostBody(parms: params)

        request.httpBody = postData

        fetch(request: request) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func patchProduct(productId: String) {
        let identifier = "d1fb22fc-0335-11ed-9676-3bb3eb48793a"
        
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
    
    func deleteProduct(productId: String, secret: String) {
        let components = URLComponents(string: NetworkNamespace.url.name)
        let identifier = "d1fb22fc-0335-11ed-9676-3bb3eb48793a"
        
        guard var url = components?.url else { return }
        
        url.appendPathComponent(productId)
        url.appendPathComponent(secret)
        
        var request = URLRequest(url: url)
        
        print(request.url)
        
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
