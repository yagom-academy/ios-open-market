//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import Foundation
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
        guard let url = URL(string: NetworkNamespace.url.name) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = NetworkNamespace.post.name

        let boundary = "\(UUID().uuidString)"
        request.addValue("multipart/form-data; boundary=\"\(boundary)\"", forHTTPHeaderField: "Content-Type")

        request.addValue("d1fb22fc-0335-11ed-9676-3bb3eb48793a", forHTTPHeaderField: "identifier")
        
        var postData = Data()

        let params: [String: Any] = ["name": "테스트중", "descriptions": "테스트중임", "price": 222, "currency": Currency.KRW.rawValue, "secret": "lP8VFiBqGI"]
        
        guard let jsonData = OpenMarketRequest().createPostJson(params: params) else { return }
      
        postData.append("--\(boundary)\r\n".data(using: .utf8)!)
        postData.append("Content-Disposition: form-data; name=\"params\"\r\n".data(using: .utf8)!)
        postData.append("Content-Type: application/json\r\n\r\n".data(using: .utf8)!)

        postData.append(jsonData)
        postData.append("\r\n".data(using: .utf8)!)

        postData.append("--\(boundary)\r\n".data(using: .utf8)!)
        postData.append("Content-Disposition: form-data; name=\"images\"; filename=\"unchain.png\"\r\n".data(using: .utf8)!)
        postData.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        
        let imageData = UIImage(named: "unchain")
        guard let imageDataSrc = imageData?.pngData() else {
            print("이미지 실패")
            return }
        postData.append(imageDataSrc)
        postData.append("\r\n".data(using: .utf8)!)
        postData.append("--\(boundary)--".data(using: .utf8)!)
        
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
}
