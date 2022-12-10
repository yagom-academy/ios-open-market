//
//  NetworkManager.swift
//  OpenMarket
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import UIKit

struct NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func loadThumbnailImage(of url: String,
                            completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.transportError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(NetworkError.serverError))
                return
            }
            
            guard let data = data,
                  let image = UIImage(data: data)
            else {
                completion(.failure(NetworkError.missingData))
                return
            }
            
            completion(.success(image))
        }
        
        task.resume()
    }
    
    func loadData<T: Decodable>(of request: NetworkRequest,
                                dataType: T.Type,
                                completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = request.url else { return }
        
        let task = session.dataTask(with: url) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.transportError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                completion(.failure(NetworkError.serverError))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.missingData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                
                let data = try decoder.decode(T.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(NetworkError.failedToParse))
            }
        }
        
        task.resume()
    }
    
    func postData(request: URLRequest, data: Data, completion: @escaping () -> Void) {
        let task = session.uploadTask(with: request, from: data) { _, response, error in
            guard error == nil else { return }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                return
            }
            
            completion()
        }
        task.resume()
    }
    
    func configureRequest(_ boundary: String) -> URLRequest? {
        guard let url = NetworkRequest.postProduct.url else {
            return nil
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue("3595be32-6941-11ed-a917-b17164efe870",
                         forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func configureRequestBody(_ product: PostProduct, _ imageData: Data, _ boundary: String) -> Data? {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        guard let productData = try? encoder.encode(product) else {
            return nil
        }
        
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"params\"\r\n\r\n")
        data.append(productData)
        data.appendString("\r\n")
        data.append(imageData)
        data.appendString("\r\n--\(boundary)--\r\n")
        
        return data
    }
}
