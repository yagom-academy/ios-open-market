//
//  HTTPManager.swift
//  OpenMarket
//
//  Created by papri, Tiana on 10/05/2022.
//

import Foundation

fileprivate enum StatusCode {
    static let okSuccess = 200
    static let createdSuccess = 201
    static let acceptedSuccess = 202
    static let successRange = 200 ... 299
}

fileprivate enum ContentType {
    static let applicationJson = "application/json"
    static let textPlain = "text/plain"
}

struct HTTPManager {
    enum TargetURL {
        static let hostURL = "https://market-training.yagom-academy.kr/"
        case healthChecker
        case productList(pageNumber: Int, itemsPerPage: Int)
        case productDetail(productNumber: Int)
        
        var string: String {
            switch self {
            case .healthChecker:
                return "/healthChecker"
            case .productList(let pageNumber, let itemsPerPage):
                return "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
            case .productDetail(let productNumber):
                return "/api/products/\(productNumber)"
            }
        }
        
        var requestURL: String {
            return HTTPManager.TargetURL.hostURL + string
        }
    }
    private let hostURL: String
    private let urlSession: URLSession
    
    init(hostURL: String = TargetURL.hostURL, urlSession: URLSession = URLSession.shared) {
        self.hostURL = hostURL
        self.urlSession = urlSession
    }
    
    @discardableResult
    func listenHealthChecker(completionHandler: @escaping (Result<HTTPURLResponse, NetworkError>) -> Void) -> URLSessionDataTask? {
        let requestURL = TargetURL.healthChecker.requestURL
        guard let url = URL(string: requestURL) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.invalidStatusCode(error: error, statusCode: nil)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  StatusCode.okSuccess == httpResponse.statusCode else {
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: nil)))
                return
            }
            if httpResponse.statusCode == StatusCode.okSuccess {
                completionHandler(.success(httpResponse))
                return
            }
            completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: httpResponse.statusCode)))
        }
        task.resume()
        return task
    }
    
    @discardableResult
    func loadData(targetURL: TargetURL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        let requestURL = targetURL.requestURL
        guard let url = URL(string: requestURL) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let _ = error {
                completionHandler(.failure(.invalidStatusCode(error: error, statusCode: nil)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (StatusCode.successRange).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: nil)))
                return
            }
            if let mimeType = httpResponse.mimeType,
               mimeType == ContentType.applicationJson,
               let data = data {
                completionHandler(.success(data))
                return
            }
            completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: httpResponse.statusCode)))
        }
        task.resume()
        return task
    }
}
