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
        request.addValue(Multipart.boundary + "\"\(boundary)\"", forHTTPHeaderField: Multipart.contentType)
        request.addValue("d1fb22fc-0335-11ed-9676-3bb3eb48793a", forHTTPHeaderField: Request.identifier)
        
        var postData = Data()

        let params: [String: Any] = ["name": "테스트중", "descriptions": "테스트중임", "price": 222, "currency": Currency.KRW.rawValue, "secret": "lP8VFiBqGI"]
        
        guard let jsonData = OpenMarketRequest().createPostJson(params: params) else { return }

        postData.append(form: "--\(boundary)\r\n")
        postData.append(form: Multipart.paramContentDisposition)
        postData.append(form: Multipart.paramContentType)

        postData.append(jsonData)
        postData.append(form: Multipart.lineFeed)

        postData.append(form: "--\(boundary)" + Multipart.lineFeed)
        postData.append(form: Multipart.imageContentDisposition + "\"unchain.png\"" + Multipart.lineFeed)
        postData.append(form: ImageType.png.name)

        let imageData = UIImage(named: "unchain")
        guard let imageDataSrc = imageData?.pngData() else { return }
        postData.append(imageDataSrc)
        postData.append(form: Multipart.lineFeed)
        postData.append(form: "--\(boundary)--")

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
