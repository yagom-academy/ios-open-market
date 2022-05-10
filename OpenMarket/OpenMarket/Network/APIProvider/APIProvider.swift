//
//  APIProvider.swift
//  OpenMarket
//
//  Created by 조민호 on 2022/05/10.
//

import Foundation

typealias DataTaskCompletionHandler = (Data?, URLResponse?, Error?) -> Void

protocol URLSessionProtocol {
    func dataTask(with url: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

protocol Provider {
    associatedtype T
    func request(with endpoint: Requestable, completion: @escaping (Result<T, Error>) -> Void)
}

final class APIProvider<T: Decodable>: Provider {
    let urlSession: URLSessionProtocol
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func request(with endpoint: Requestable, completion: @escaping (Result<T, Error>) -> Void) {
        let urlRequest = endpoint.generateUrlRequest()
        
        switch urlRequest {
        case .success(let urlRequest):
            urlSession.dataTask(with: urlRequest) { [weak self] data, response, error in
                self?.checkError(with: data, response, error) { result in
                    guard let self = self else { return }
                    switch result {
                    case .success(let data):
                        completion(self.decode(data: data))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            }.resume()
        case .failure(let error):
            completion(.failure(NetworkError.urlRequest(error)))
        }
    }

    private func checkError(with data: Data?, _ response: URLResponse?, _ error: Error?, completion: @escaping (Result<Data, Error>) -> ()) {
        if let error = error {
            completion(.failure(error))
            return
        }

        guard let response = response as? HTTPURLResponse else {
            completion(.failure(NetworkError.unknownError))
            return
        }

        guard (200...299).contains(response.statusCode) else {
            completion(.failure(NetworkError.invalidHttpStatusCode(response.statusCode)))
            return
        }

        guard let data = data else {
            completion(.failure(NetworkError.emptyData))
            return
        }

        completion(.success((data)))
    }

    private func decode(data: Data) -> Result<T, Error> {
        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return .success(decoded)
        } catch {
            return .failure(NetworkError.emptyData)
        }
    }
}
