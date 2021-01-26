
import Foundation

enum OpenMarketNetworkError: Error {
    case invalidData
    case failedHTTPRequest
    case decodingFailure
}

struct OpenMarketAPIManager {
    private let baseURL = "https://camp-open-market.herokuapp.com"
    
    func getProductList(of page: Int) {
        let urlRequest = makeProductListRequestURL(of: page)
        fetchProductList(with: urlRequest) { (result) in
            switch result {
            case .success(let productList):
                dump(productList)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func fetchProductList(with urlRequest: URLRequest, completionHandler: @escaping (Result<ProductList, OpenMarketNetworkError>) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { (data, response, error)  in
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
    
    private func makeProductListRequestURL(of page: Int) -> URLRequest {
        guard let validURL = URL(string: "\(baseURL)/items/\(page)/") else {
            preconditionFailure("URL 생성 error")
        }
        
        var urlRequest = URLRequest(url: validURL)
        urlRequest.httpMethod = "GET"
        
        return urlRequest
    }
    
}
