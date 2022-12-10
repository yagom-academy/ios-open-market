//  NetworkManager.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/15.

import Foundation

final class NetworkManager {
    private let session: URLSessionable
    
    init(session: URLSessionable = URLSession.shared) {
        self.session = session
    }
    
    func checkAPIHealth(completion: @escaping (Result<HTTPURLResponse, NetworkError>) -> Void) {
        guard let urlRequest = Endpoint.healthChecker.createURLRequest(httpMethod: .get) else { return }
            
        let task = session.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                return completion(.failure(.URLError))
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                      return completion(.failure(.statusCodeError))
            }
            
            completion(.success(response))
        }
        
        task.resume()
    }
	
	func fetchProductList(_ page: Int, completion: @escaping ((Result<ProductList, NetworkError>) -> Void)) {
		let endpoint = Endpoint.fetchProductList(pageNumber: page)
		guard let urlRequest = endpoint.createURLRequest(httpMethod: .get) else { return }
		session.request(urlRequest: urlRequest) { result in
			switch result {
			case .success(let data):
				guard let productList = try? JSONDecoder().decode(ProductList.self, from: data) else { return }
				completion(.success(productList))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
	
	func fetchProductDetail(id: Int, completion: @escaping ((Result<Product, NetworkError>) -> Void)) {
		let endpoint = Endpoint.fetchProductDetail(id: id)
		guard let urlRequest = endpoint.createURLRequest(httpMethod: .get) else { return }
		session.request(urlRequest: urlRequest) { result in
			switch result {
			case .success(let data):
				guard let product = try? JSONDecoder().decode(Product.self, from: data) else { return }
				completion(.success(product))
			case .failure(let error):
				completion(.failure(error))
			}
		}
	}
}
