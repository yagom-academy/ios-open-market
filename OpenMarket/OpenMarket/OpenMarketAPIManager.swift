
import Foundation
import UIKit

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
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
    static let baseURL = "https://camp-open-market.herokuapp.com"
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchProductList(of page: Int, completionHandler: @escaping (Result<ProductList, OpenMarketNetworkError>) -> Void) {
        guard let urlRequest = OpenMarketURLMaker.makeRequestURL(httpMethod: .get, mode: .listSearch(page: page)) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
        fetchData(feature: .listSearch(page: page), url: urlRequest, completion: completionHandler)
    }
    
    func requestRegistration(of product: Product, completionHandler: @escaping (Result<Any,OpenMarketNetworkError>) -> ()) {
        guard var urlRequest = OpenMarketURLMaker.makeRequestURL(httpMethod: .post, mode: .productRegistration) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let mimeType = "image/jpg"
        
        let params: [String : Any] = [
            "title" : product.title,
            "descriptions" : product.descriptions ?? "",
            "price" : product.price,
            "currency" : product.currency,
            "stock" : product.stock,
            "discounted_price" : product.discountedPrice  ?? 0,
            "password" : product.password ?? ""
        ]
        
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key,value) in params {
            body.append(string: boundaryPrefix, encoding: .utf8)
            body.append(string: "Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n", encoding: .utf8)
            body.append(string: "\(value)\r\n", encoding: .utf8)
        }

        guard let image = UIImage(systemName: "bell") else {
            print("이미지 변환 실패")
            return
        }
        guard let imageConvertedToData = image.jpegData(compressionQuality: 1.0) else {
            print("이미지 변환 실패 2")
            return
        }
        
        var dataArray = [Data]()
        var imageArray = [imageConvertedToData]
        for (index, image) in imageArray.enumerated() {
            dataArray.append(image)
        }
        
        for (index,data) in dataArray.enumerated() {
            body.append(string: boundaryPrefix, encoding: .utf8)
            body.append(string: "Content-Disposition: form-data; name=\"images\"; filename=\"image\"\(index)\"\r\n", encoding: .utf8)
            body.append(string: "Content-Type: \(mimeType)\r\n\r\n", encoding: .utf8)
            body.append(data)
            body.append(string: "\r\n", encoding: .utf8)
        }
        body.append(string: "--".appending(boundary.appending("--")), encoding: .utf8)
        
        urlRequest.httpBody = body
        
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { data,response,error in
            guard let postingData = data else {
                completionHandler(.failure(.invalidData))
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(.failedHTTPRequest))
                return
            }

            completionHandler(.success(postingData))
        }
        dataTask.resume()
    }
}
extension OpenMarketAPIManager {
    private func fetchData<T: Decodable>(feature: FeatureList, url: URLRequest, completion: @escaping (Result<T,OpenMarketNetworkError>) -> Void) {
        let dataTask: URLSessionDataTask = session.dataTask(with: url) { (data, response, error)  in
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
            case .listSearch(let page):
                do {
                    let productList = try JSONDecoder().decode(T.self, from: receivedData)
                    completion(.success(productList))
                } catch {
                    completion(.failure(.decodingFailure))
                }
            case .productRegistration:
                break
            case .deleteProduct(let id):
                break
            case .productSearch(let id):
                break
            case .productModification(let id):
                break
            }
        }
        dataTask.resume()
    }
}
extension Data {
    mutating func append(string: String, encoding: String.Encoding) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
}
