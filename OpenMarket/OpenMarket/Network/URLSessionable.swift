//  URLSessionable.swift
//  OpenMarket
//  Created by SummerCat & Bella on 2022/11/21.

import Foundation

protocol URLSessionable {
    func dataTask(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSessionable {
	@discardableResult
	func request(
		urlRequest: URLRequest,
		completion: @escaping (Result<Data, NetworkError>) -> Void
	) -> URLSessionDataTask {
		let task = dataTask(with: urlRequest) { data, response, error in
			guard error == nil else {
				return completion(.failure(.URLError))
			}
			
			guard let response = response as? HTTPURLResponse,
				  (200..<300).contains(response.statusCode) else {
					  return completion(.failure(.statusCodeError))
			}
			
			guard let data else {
				return completion(.failure(.noData))
			}
			
			completion(.success(data))
		}
		
		task.resume()
		return task
	}
}
