import Foundation

class APIManager {
    let apiHost = "https://market-training.yagom-academy.kr/"
    var healthChecker: String?
    var product: ProductInformation?
    var productList: ProductList?
    var semaphore = DispatchSemaphore(value: 0)
    let successRange = 200..<300
    
    func requestHealthChecker() {
        let url = apiHost + "healthChecker"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = HTTPMethod.get
 
    }
    
    func requestProductInformation(productID: Int, completionHandler: @escaping (Result<ProductInformation, Error>) -> Void) {
        let url = apiHost + "/api/products/" + "\(productID)"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
        request.httpMethod = HTTPMethod.get
        createDataTask(with: request, completionHandler)
    }
    
    func requestProductList(completionHandler: @escaping (Result<ProductList, Error>) -> Void) {
        let url = apiHost + "/api/products?page-no=1&items-per-page=10"
        var request = URLRequest(url: URL(string: url)!,timeoutInterval: Double.infinity)
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
