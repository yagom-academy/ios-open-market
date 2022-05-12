//
//  Requestable.swift
//  OpenMarket
//
//  Created by Red, Mino on 2022/05/10.
//

import Foundation

protocol Requestable {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethod { get }
    var queryParameters: Encodable? { get }
    var bodyParameters: Encodable? { get }
    var headers: [String: String]? { get }
    var sampleData: Data? { get }
}

extension Requestable {
    func generateUrlRequest() -> Result<URLRequest, NetworkError> {
        let url = generateURL()
        var urlRequest: URLRequest
        
        switch url {
        case.success(let url):
            urlRequest = URLRequest(url: url)
        case.failure(let error):
            return .failure(error)
        }

        if let bodyParameters = bodyParameters?.toDictionary() {
            switch bodyParameters {
            case.success(let body):
                if body.isEmpty == false {
                    do {
                        urlRequest.httpBody = try JSONSerialization.data(withJSONObject: bodyParameters)
                    } catch {
                        return .failure(.decodeError)
                    }
                }
            case.failure(let error):
                return .failure(error)
            }
        }

        urlRequest.httpMethod = method.rawValue
        headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        return .success(urlRequest)
    }

    private func generateURL() -> Result<URL, NetworkError> {
        let fullPath = "\(baseURL)\(path)"
        guard var urlComponents = URLComponents(string: fullPath) else {
            return .failure(.urlComponetError)
        }

        var urlQueryItems = [URLQueryItem]()
        if let queryParameters = queryParameters?.toDictionary() {
            switch queryParameters {
            case.success(let data):
                data.forEach {
                    urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
                }
            case.failure(let error):
                return .failure(error)
            }
        }
          
        urlComponents.queryItems = urlQueryItems.isEmpty == false ? urlQueryItems : nil

        guard let url = urlComponents.url else {
            return .failure(.urlComponetError)
        }
        return .success(url)
    }
}

fileprivate extension Encodable {
    func toDictionary() -> Result<[String: Any], NetworkError> {
        do {
            let data = try JSONEncoder().encode(self)
            guard let jsonData = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                return .failure(.decodeError)
            }
            return .success(jsonData)
        } catch {
            return .failure(.decodeError)
        }
    }
}
