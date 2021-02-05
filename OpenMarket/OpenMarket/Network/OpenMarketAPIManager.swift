
import Foundation
import UIKit

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionUploadTask
}

extension URLSession: URLSessionProtocol { }

enum OpenMarketNetworkError: Error {
    case invalidData
    case failedHTTPRequest
    case decodingFailure
    case invalidURL
    case failedURLRequest
}

struct OpenMarketAPIManager {
    static let shared = OpenMarketAPIManager()
    
    static let baseURL = "https://camp-open-market.herokuapp.com"
    private let boundary = UUID().uuidString
    let session: URLSessionProtocol
    
    private init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func requestProductList(of page: Int, completionHandler: @escaping (Result<ProductList, OpenMarketNetworkError>) -> Void) {
        guard let urlRequest = OpenMarketURLMaker.makeRequestURL(httpMethod: .get, mode: .listSearch(page: page)) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
        fetchData(feature: .listSearch(page: page), url: urlRequest, completion: completionHandler)
    }
    
    func requestRegistration(product: ProductRegistration, completionHandler: @escaping (Result<Data,OpenMarketNetworkError>) -> ()) {
        guard var urlRequest = OpenMarketURLMaker.makeRequestURL(httpMethod: .post, mode: .productRegistration) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let mimeType = "image/jpg"
        let params = product.description
        
        urlRequest.httpBody = createBody(boundary: boundary, mimeType: mimeType, params: params, imageArray: product.images)
        
        fetchData(feature: .productRegistration, url: urlRequest, completion: completionHandler)
    }
    
    func requestProduct(of id: Int, completionHandler: @escaping (Result<Product, OpenMarketNetworkError>) -> Void) {
        guard let urlRequest = OpenMarketURLMaker.makeRequestURL(httpMethod: .get, mode: .productSearch(id: id)) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        fetchData(feature: .productSearch(id: id), url: urlRequest, completion: completionHandler)
    }
}
extension OpenMarketAPIManager {
    private func fetchData<T: Decodable>(feature: FeatureList, url: URLRequest, completion: @escaping (Result<T,OpenMarketNetworkError>) -> Void) {
        let dataTask: URLSessionDataTask = session
            .dataTask(with: url) { (data, response, error)  in
                guard let receivedData = data else {
                    completion(.failure(.invalidData))
                    return
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200..<300).contains(response.statusCode) else {
                    completion(.failure(.failedHTTPRequest))
                    return
                }
                
                switch feature {
                case .listSearch, .productSearch:
                    do {
                        let convertedData = try JSONDecoder().decode(T.self, from: receivedData)
                        completion(.success(convertedData))
                    } catch {
                        completion(.failure(.decodingFailure))
                    }
                case .productRegistration:
                    completion(.success(receivedData as! T))
                case .deleteProduct(let id):
                    break
                case .productModification(let id):
                    break
                }
            }
        dataTask.resume()
    }
    
    private func createBody(boundary: String, mimeType: String, params: [String : Any?], imageArray: [Data]) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key,value) in params {
            if let convertedValue = value {
                body.append(string: boundaryPrefix, encoding: .utf8)
                body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n", encoding: .utf8)
                body.append(string: "\(convertedValue)\r\n", encoding: .utf8)
            }
        }
        
        for (index,data) in imageArray.enumerated() {
            body.append(string: boundaryPrefix, encoding: .utf8)
            body.append(string: "Content-Disposition: form-data; name=\"images\"; filename=\"image\"\(index)\"\r\n", encoding: .utf8)
            body.append(string: "Content-Type: \(mimeType)\r\n\r\n", encoding: .utf8)
            body.append(data)
            body.append(string: "\r\n", encoding: .utf8)
        }
        body.append(string: "--".appending(boundary.appending("--")), encoding: .utf8)
        
        return body
    }
}

extension Data {
    mutating func append(string: String, encoding: String.Encoding) {
        if let data = string.data(using: encoding) { append(data) }
    }
}

