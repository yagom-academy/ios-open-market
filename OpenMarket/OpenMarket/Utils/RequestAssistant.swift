//
//  RequestAssistant.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation

final class RequestAssistant {
    private let sessionManager = URLSessionGenerator(session: URLSession.shared)
    
    func requestListAPI(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping ((Result<ProductList, OpenMarketError>) -> Void)) {
        
        let endpoint: Endpoint = .productList(nubmers: pageNumber, pages: itemsPerPage)
        
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? Decoder.shared.decode(ProductList.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    func requestDetailAPI(productId: Int, completionHandler: @escaping ((Result<Product, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .productDetail(productId: productId)
        
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            guard let result = try? Decoder.shared.decode(Product.self, from: data) else {
                completionHandler(.failure(.failDecode))
                return
            }
            self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
        })
    }
    
    func requestHealthCheckerAPI(completionHandler: @escaping ((Result<String, OpenMarketError>) -> Void)) {
        let endpoint: Endpoint = .healthCheck
        sessionManager.request(endpoint: endpoint, completionHandler: { [weak self] data, response, error in
            guard let data = data else {
                return
            }
            if let result = String(data: data, encoding: .utf8) {
                self?.handleResponse(response: response, result: result, completionHandler: completionHandler)
            }
        })
    }
    
    private func handleResponse<T>(response: URLResponse?, result: T ,completionHandler: @escaping ((Result<T, OpenMarketError>) -> Void)) {
        guard let response = response as? HTTPURLResponse else {
            return
        }
        let statusCode = response.statusCode
        switch statusCode {
        case 200...299:
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
}

enum Endpoint {
    case productList(nubmers: Int, pages: Int)
    case productDetail(productId: Int)
    case healthCheck
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
