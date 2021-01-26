
import Foundation

enum ProductError: Error {
    case error
}

struct OpenMarketAPINetwork {
    func decodeFromAPI(completionHandler: @escaping (Result<ProductList, ProductError>) -> ()) {
        let session = URLSession(configuration: .default)
        guard let url:URL = URL(string: "https://camp-open-market.herokuapp.com/items/1/") else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        let dataTask = session.dataTask(with: urlRequest) { data,_,error  in
            guard let data = data else {
                return
            }
            do {
                let productlist: ProductList = try JSONDecoder().decode(ProductList.self, from: data)
                completionHandler(.success(productlist))
            } catch {
                print("JSON 에러")
                completionHandler(.failure(.error))
            }
        }
        dataTask.resume()
    }
    
}
