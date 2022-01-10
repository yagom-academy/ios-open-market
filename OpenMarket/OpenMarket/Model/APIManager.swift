import Foundation

class APIManager {
    let apiHost = "https://market-training.yagom-academy.kr/"
    let successRange = 200..<300
    
    func requestHealthChecker(completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: apiHost + "healthChecker") else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, self.successRange.contains(statusCode) else {
                completionHandler(.failure(URLSessionError.statusCodeError))
                return
            }
            
            guard error == nil else {
                completionHandler(.failure(URLSessionError.requestFail))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(URLSessionError.invalidData))
                return
            }
            
            completionHandler(.success(data))
        }
        task.resume()
        
    }
    
    func requestProductInformation(productID: Int, completionHandler: @escaping (Result<ProductInformation, Error>) -> Void) {
        guard let url = URL(string: apiHost + "/api/products/" + "\(productID)") else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        createDataTask(with: request, completionHandler)
    }
    
    func requestProductList(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<ProductList, Error>) -> Void) {
        var urlComponents = URLComponents(string: apiHost + "/api/products?")
        let pageNumberQuery = URLQueryItem(name: "page_no", value: "\(pageNumber)")
        let itemsPerPageQuery = URLQueryItem(name: "items_per_page", value: "\(itemsPerPage)")
        urlComponents?.queryItems?.append(pageNumberQuery)
        urlComponents?.queryItems?.append(itemsPerPageQuery)
        
        guard let url = urlComponents?.url else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HTTPMethod.get
        createDataTask(with: request, completionHandler)
    }
}

extension APIManager {
    func createDataTask<Element: Decodable>(with request: URLRequest, _ completionHandler: @escaping (Result<Element, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, self.successRange.contains(statusCode) else {
                completionHandler(.failure(URLSessionError.statusCodeError))
                return
            }
            
            guard error == nil else {
                completionHandler(.failure(URLSessionError.requestFail))
                return
            }
            
            guard let data = data else {
                completionHandler(.failure(URLSessionError.invalidData))
                return
            }
            
            guard let parsedData = Parser<Element>.decode(from: data) else {
                completionHandler(.failure(ParserError.decodeFail))
                return
            }
            
            completionHandler(.success(parsedData))
        }
        task.resume()
    }
}
