
import Foundation

enum OpenMarketNetworkError: Error {
    case invalidData
    case failedHTTPRequest
    case decodingFailure
}

struct OpenMarketAPINetwork {
    private func fetchProductList(page: Int, completionHandler: @escaping (Result<ProductList, OpenMarketNetworkError>) -> ()) {
        guard let url = URL(string: "https://camp-open-market.herokuapp.com/items/\(page)/") else {
            return
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
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
                let productlist = try JSONDecoder().decode(ProductList.self, from: receivedData)
                completionHandler(.success(productlist))
            } catch {
                completionHandler(.failure(.decodingFailure))
            }
        }
        dataTask.resume()
    }
    
}
