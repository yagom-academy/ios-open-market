//  Created by Aejong, Tottale on 2022/11/17.

import UIKit

final class NetworkAPIProvider {
    
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func fetchProductList(query: [Query: String]?,
                          completion: @escaping (Result<ProductList, Error>) -> Void) {
        fetch(path: .productList(query: query)) { result in
            switch result {
            case .failure(let error):
                completion(.failure(error))
            case .success(let data):
                guard let productList: ProductList = JSONDecoder().decode(data: data) else {
                    completion(.failure(NetworkError.decodeFailed))
                    return
                }
                completion(.success(productList))
            }
        }
    }
    
    func fetchImage(url: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            guard let url = URL(string: url) else { return }
            URLSession.shared.dataTask(with: url) { (data, result, error) in
                
                if let error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data, let image = UIImage(data: data) {
                    completion(.success(image))
                }
                
            }.resume()
        }
    }
}

extension NetworkAPIProvider {
    
    func fetch(path: NetworkAPI, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = path.urlComponents.url else { return }
        
        self.session.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NetworkError.serverFailed))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}
