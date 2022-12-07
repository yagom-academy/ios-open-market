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
        let task = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
            guard error == nil else { return }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode)
            else {
                return
            }
            guard let data = data else { return }
            completion()
            print(data)
        }
        task.resume()
    }
}
