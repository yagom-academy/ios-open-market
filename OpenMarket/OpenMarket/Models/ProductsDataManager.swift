import Foundation

struct ProductsDataManager {
    let url = "https://market-training.yagom-academy.kr/api/products"
    
    func getData(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<Products, Error>) -> Void) {
        
        var urlComponent = URLComponents(string: url)
        urlComponent?.queryItems = [
            URLQueryItem(name: "page_no", value: String(pageNumber)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
        
        guard let urlComponentURL = urlComponent?.url else { return }
        
        let request = URLRequest(url: urlComponentURL)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            if let urlError = responseErrorhandling(response: response) {
                completion(.failure(urlError))
                return
            }
            
            guard let data = data else {
                let decodingContext = makeContext(by: "data")
                completion(.failure(DecodingError.dataCorrupted(decodingContext)))
                return
            }
            
            guard let decodedData = try? JSONDecoder().decode(Products.self, from: data) else {
                let decodingContext = makeContext(by: "JSON")
                completion(.failure(DecodingError.typeMismatch(Products.self, decodingContext)))
                return
            }
            
            completion(.success(decodedData))
        }
        task.resume()
    }
    
    private func makeContext(by errorDebugDescription: String) -> DecodingError.Context {
        let decodingContext = DecodingError.Context.init(codingPath: Products.CodingKeys.allCases, debugDescription: "Can't response \(errorDebugDescription)")
        return decodingContext
    }
    
    private func responseErrorhandling(response: URLResponse?) -> URLSessionError? {
        guard let response = response as? HTTPURLResponse else { return nil }
        switch response.statusCode {
        case 300..<400:
                return URLSessionError.redirection
        case 400..<500:
            return URLSessionError.clientError
        case 500..<600:
            return URLSessionError.serverError
        default:
            return nil
        }
    }
}
