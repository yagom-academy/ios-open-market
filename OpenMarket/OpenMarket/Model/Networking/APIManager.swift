import Foundation

class APIManager {
    let successRange = 200..<300
    
    private func request(_ url: URL, _ httpMethod: String) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        
        return request
    }
    
    func requestHealthChecker(completionHandler: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URLManager.healthChecker.url else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        let request = request(url, HTTPMethod.get)
 
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(URLSessionError.requestFail))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, self.successRange.contains(statusCode) else {
                completionHandler(.failure(URLSessionError.statusCodeError))
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
        guard let url = URLManager.productInformation(productID).url else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        let request = request(url, HTTPMethod.get)
        createDataTask(with: request, completionHandler)
    }
    
    func requestProductList(pageNumber: Int, itemsPerPage: Int, completionHandler: @escaping (Result<ProductList, Error>) -> Void) {
        guard let url = URLManager.productList(pageNumber, itemsPerPage).url else {
            completionHandler(.failure(URLSessionError.urlIsNil))
            return
        }
        
        let request = request(url, HTTPMethod.get)
        createDataTask(with: request, completionHandler)
    }
}

extension APIManager {
    func createDataTask<Element: Decodable>(with request: URLRequest, _ completionHandler: @escaping (Result<Element, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(URLSessionError.requestFail))
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, self.successRange.contains(statusCode) else {
                completionHandler(.failure(URLSessionError.statusCodeError))
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
