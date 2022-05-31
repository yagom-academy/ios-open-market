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
        case productPost
        case productPatch(productIdentifier: Int)
        
        var string: String {
            switch self {
            case .healthChecker:
                return "/healthChecker"
            case .productList(let pageNumber, let itemsPerPage):
                return "/api/products?page_no=\(pageNumber)&items_per_page=\(itemsPerPage)"
            case .productDetail(let productNumber):
                return "/api/products/\(productNumber)"
            case .productPost:
                return "/api/products/"
            case .productPatch(let productIdentifier):
                return "/api/products/\(productIdentifier)"
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
            if let error = error {
                completionHandler(.failure(.invalidStatusCode(error: error, statusCode: nil)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  StatusCode.okSuccess == httpResponse.statusCode else {
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: nil)))
                return
            }
            
            switch httpResponse.statusCode {
            case StatusCode.okSuccess:
                completionHandler(.success(httpResponse))
            default:
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: httpResponse.statusCode)))
            }
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
            if let error = error {
                completionHandler(.failure(.invalidStatusCode(error: error, statusCode: nil)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (StatusCode.successRange).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: nil)))
                return
            }
        
            switch httpResponse.statusCode {
            case StatusCode.okSuccess where httpResponse.mimeType == ContentType.applicationJson:
                guard let data = data else {
                    completionHandler(.failure(.emptyData))
                    return
                }
                completionHandler(.success(data))
            default:
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: httpResponse.statusCode)))
            }
        }
        task.resume()
        return task
    }
    
    @discardableResult
    func postProductData(images: [Data], product: [String : Any], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        let requestURL = TargetURL.productPost.requestURL
        guard let url = URL(string: requestURL) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        
        var request = URLRequest(url: url ,cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        
        request.addValue("a09d8d1a-d1b8-11ec-9676-bd41bb2bb233", forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        guard let data = createMultipartBody(images: images, product: product, boundary: boundary) else {
            return nil
        }
        request.httpBody = data
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(.invalidStatusCode(error: error, statusCode: nil)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (StatusCode.successRange).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: nil)))
                return
            }
        
            switch httpResponse.statusCode {
            case StatusCode.createdSuccess where httpResponse.mimeType == ContentType.applicationJson:
                guard let data = data else {
                    completionHandler(.failure(.emptyData))
                    return
                }
                completionHandler(.success(data))
            default:
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: httpResponse.statusCode)))
            }
        }
        task.resume()
        return task
    }
    
    func createMultipartBody(images: [Data], product: [String : Any], boundary: String) -> Data? {
        var data = Data()
        var product = product
        product.updateValue("80sgmjjk9v", forKey: "secret")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: product) else {
            return nil
        }
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8)!)
        data.append(jsonData)
        
        for (index, image) in images.enumerated() {
            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
            let fileName = "image" + "\(index)"
            
            data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(fileName).jpg\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpg\r\n\r\n".data(using: .utf8)!)
            data.append(image)
        }
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return data
    }
    
    func patchData(product: [String : Any], targetURL: TargetURL, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask? {
        let requestURL = targetURL.requestURL
        guard let url = URL(string: requestURL) else {
            completionHandler(.failure(.invalidURL))
            return nil
        }
        
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)
        request.httpMethod = "PATCH"
        
        request.addValue("a09d8d1a-d1b8-11ec-9676-bd41bb2bb233", forHTTPHeaderField: "identifier")
       
        var product = product
        product.updateValue("80sgmjjk9v", forKey: "secret")
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: product) else {
            return nil
        }
        
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completionHandler(.failure(.invalidStatusCode(error: error, statusCode: nil)))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (StatusCode.successRange).contains(httpResponse.statusCode) else {
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: nil)))
                return
            }
        
            switch httpResponse.statusCode {
            case StatusCode.acceptedSuccess where httpResponse.mimeType == ContentType.applicationJson:
                guard let data = data else {
                    completionHandler(.failure(.emptyData))
                    return
                }
                completionHandler(.success(data))
            default:
                completionHandler(.failure(.invalidStatusCode(error: nil, statusCode: httpResponse.statusCode)))
            }
        }
        task.resume()
        return task
    }
}
