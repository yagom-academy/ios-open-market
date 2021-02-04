
import Foundation

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
    private let boundary = UUID().uuidString
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession(configuration: .default)) {
        self.session = session
    }
    
    func fetchProductList(of page: Int, completionHandler: @escaping (Result<ProductList, OpenMarketNetworkError>) -> Void) {
        guard let urlRequest = OpenMarketURLMaker.makeRequestURL(httpMethod: .get, mode: .listSearch(page: page)) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { (data, response, error)  in
            guard let receivedData = data else {
                completionHandler(.failure(.invalidURL))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(.failedHTTPRequest))
                return
            }
            
            do {
                let productList = try JSONDecoder().decode(ProductList.self, from: receivedData)
                completionHandler(.success(productList))
            } catch {
                completionHandler(.failure(.decodingFailure))
            }
        }
        
        dataTask.resume()
    }
    
    func requestRegistration(product: ProductRegistration, completionHandler: @escaping (Result<Any,OpenMarketNetworkError>) -> ()) {
        
        guard var urlRequest = OpenMarketURLMaker.makeRequestURL(httpMethod: .post, mode: .productRegistration) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = convertMultipartFormData(product)
        
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
    
    func convertMultipartFormData(_ bodyData: ProductRegistration) -> Data {
        var body = Data()
        
        for (key, value) in bodyData.description {
            if let data = value as? [Data] {
                body.append(setUpMultipartFormData(key: key, value: data))
            } else if let value = value {
                body.append(setUpMultipartForm(key: key, value: value))
            }
        }
        let suffixBoundary = "--\(boundary)--\r\n"
        body.append(suffixBoundary)
        
        return body
    }
    
    private func setUpMultipartForm(key: String, value: Any) -> Data {
        var body = Data()
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
        if let data = value as? String {
            body.append(data)
        } else if let data = value as? Int {
            body.append(String(data))
        }
        body.append("\r\n")
        
        return body
    }
    
    private func setUpMultipartFormData(key: String, value: [Data]) -> Data {
        var body = Data()
        
        for image in value {
            body.append("--\(boundary)\r\n")
            body.append("Content-Disposition: form-data; name=\"\(key)[]\"; filename=\"pen.png\"\r\n")
            body.append("Content-Type: image/png\r\n\r\n")
            body.append(image)
            body.append("\r\n")
        }
        
        return body
    }
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) { append(data) }
    }
}

