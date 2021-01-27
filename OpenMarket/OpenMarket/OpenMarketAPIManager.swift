
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
    private let baseURL = "https://camp-open-market.herokuapp.com"
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func fetchProductList(of page: Int, completionHandler: @escaping (Result<ProductList, OpenMarketNetworkError>) -> Void) {
        guard let urlRequest = makeProductListRequestURL(of: page, httpMethod: .get, mode: .listSearch) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
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
    
    func makeProductListRequestURL(of page: Int? = nil, id: Int? = nil, httpMethod: HTTPMethods, mode: FeatureList) -> URLRequest? {
        var validURL: URL?
        
        if let page = page {
            validURL = URL(string: "\(baseURL)\(mode.urlPath)\(page)/")
        } else if let id = id {
            validURL = URL(string: "\(baseURL)\(mode.urlPath)\(id)")
        } else {
            validURL = URL(string: "\(baseURL)\(mode.urlPath)")
        }
        guard let absoluteURL = validURL else {
            print(OpenMarketNetworkError.invalidURL)
            return nil
        }
        var urlRequest = URLRequest(url: (absoluteURL))
        urlRequest.httpMethod = httpMethod.rawValue
        
        return urlRequest
    }
    
    func requestProductRegistration(product: Product, completionHandler: @escaping (Result<Any,OpenMarketNetworkError>) -> ()) {
        
        guard var urlRequest = makeProductListRequestURL(httpMethod: .post, mode: .productRegistration) else {
            print(OpenMarketNetworkError.failedURLRequest)
            return
        }
        
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let productData = try! JSONEncoder().encode(product)
        urlRequest.httpBody = productData
        
        let dataTask = URLSession.shared.uploadTask(with: urlRequest, from: productData) { data,response,error in
            guard let sendingData = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode) else {
                completionHandler(.failure(.failedHTTPRequest))
                return
            }
            
            completionHandler(.success(sendingData))
        }
        dataTask.resume()
    }
}
