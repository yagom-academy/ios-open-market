
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
}

struct OpenMarketAPIManager {
    private let baseURL = "https://camp-open-market.herokuapp.com"
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchProductList(of page: Int, completionHandler: @escaping (Result<ProductList, OpenMarketNetworkError>) -> Void) {
        let urlRequest = makeProductListRequestURL(of: page)
        
        let dataTask: URLSessionDataTask = session.dataTask(with: urlRequest) { (data, response, error)  in
            
            guard let receivedData = data else {
                completionHandler(.failure(.invalidData))
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
    
    func makeProductListRequestURL(of page: Int) -> URLRequest {
        guard let validURL = URL(string: "\(baseURL)/items/\(page)/") else {
            preconditionFailure("URL 생성 error")
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
}
