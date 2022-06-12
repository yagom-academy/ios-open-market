//
//  RequestAssistant.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import UIKit

final class RequestAssistant {
    static let shared = RequestAssistant()
    private let sessionManager = URLSessionGenerator(session: URLSession.shared)
    
    private init() { }
    
    func requestListAPI(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping ((Result<ProductList, OpenMarketError>) -> Void)) {
        
        let endpoint: Endpoint = .productList(nubmers: pageNumber, pages: itemsPerPage)
        
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.handleResponse(response: response, data: data, completionHandler: completionHandler)
        })
    }
    
    func requestDetailAPI(productId: Int, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .productDetail(productId: productId)
        
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.handleResponse(response: response, data: data, completionHandler: completionHandler)
        })
    }
    
    func requestHealthCheckerAPI(completionHandler: @escaping ((Result<String, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .healthCheck
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.handleResponse(response: response, data: data, completionHandler: completionHandler)
        })
    }
    
    func requestModifyAPI(productId: Int, body: Data, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .modifyProduct(productId: productId)
        
        sessionManager.request(endpoint: endpoint, body: body, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.handleResponse(response: response, data: data, completionHandler: completionHandler)
        })
    }
    
    func requestRegisterAPI(body: Data, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .registerProduct
        
        sessionManager.request(endpoint: endpoint, body: body, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.handleResponse(response: response, data: data, completionHandler: completionHandler)
        })
    }
    
    func requestSecretAPI(productId: Int, body: Data, completionHandler: @escaping ((Result<String, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .productSecret(productId: productId)
        sessionManager.request(endpoint: endpoint, body: body, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.handleResponse(response: response, data: data, completionHandler: completionHandler)
        })
    }
    
    func requestDeleteAPI(productId: Int, productSecret: String, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .productDelete(productId: productId, productSecret: productSecret)
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            self?.handleResponse(response: response, data: data, completionHandler: completionHandler)
        })
    }
    
    private func handleResponse<T: Decodable>(response: URLResponse?, data: Data ,completionHandler: @escaping ((Result<T, OpenMarketError>) -> Void)) {
        guard let response = response as? HTTPURLResponse else {
            return
        }
        let statusCode = response.statusCode
        switch statusCode {
        case 200...299:
            guard let result = try? Decoder.shared.decode(T.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            completionHandler(.success(result))
        case 400:
            completionHandler(.failure(.invalidData))
        case 404:
            completionHandler(.failure(.missingDestination))
        case 500...599:
            completionHandler(.failure(.invalidResponse))
        default:
            completionHandler(.failure(.unknownError))
        }
    }
    
    private func handleResponse(response: URLResponse?, data: Data ,completionHandler: @escaping ((Result<String, OpenMarketError>) -> Void)) {
        guard let response = response as? HTTPURLResponse else {
            return
        }
        let statusCode = response.statusCode
        switch statusCode {
        case 200...299:
            if let result = String(data: data, encoding: .utf8) {
                completionHandler(.success(result))
            }
        case 400:
            completionHandler(.failure(.invalidData))
        case 404:
            completionHandler(.failure(.missingDestination))
        case 500...599:
            completionHandler(.failure(.invalidResponse))
        default:
            completionHandler(.failure(.unknownError))
        }
    }
}

enum Endpoint: Equatable {
    case productList(nubmers: Int, pages: Int)
    case productDetail(productId: Int)
    case healthCheck
    case modifyProduct(productId: Int)
    case registerProduct
    case productSecret(productId: Int)
    case productDelete(productId: Int, productSecret: String)
}

extension Endpoint {
    var url: URL? {
        switch self {
        case .productList(let numbers, let pages):
            return .makeForEndpoint("/api/products?page_no=\(numbers)&items_per_page=\(pages)")
        case .productDetail(let productId):
            return .makeForEndpoint("/api/products/\(productId)")
        case .healthCheck:
            return .makeForEndpoint("/healthChecker")
        case .modifyProduct(let productId):
            return .makeForEndpoint("/api/products/\(productId)")
        case .registerProduct:
            return .makeForEndpoint("/api/products")
        case .productSecret(let productId):
            return .makeForEndpoint("/api/products/\(productId)/secret")
        case .productDelete(let productId, let productSecret):
            return .makeForEndpoint("/api/products/\(productId)/\(productSecret)")
        }
    }
    
    var method: String {
        switch self {
        case .productList(_, _), .productDetail(_), .healthCheck:
            return "GET"
        case .modifyProduct(_):
            return "PATCH"
        case .registerProduct, .productSecret(_):
            return "POST"
        case .productDelete(_, _):
            return "DELETE"
        }
    }
}

extension URL {
    static let baseURL = "https://market-training.yagom-academy.kr"
    
    static func makeForEndpoint(_ endpoint: String) -> URL? {
        URL(string: baseURL + endpoint)
    }
}

final class Decoder {
    static let shared = Decoder().decoder
    private let decoder = JSONDecoder()
    
    private init() {
        let dateFormat: DateFormatter = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormat)
    }
}
