import Foundation

struct ProductsDataManager {
    let url = "https://market-training.yagom-academy.kr/api/products"
    
    func getData<T: Decodable>(pageNumber: Int, itemsPerPage: Int, completion: @escaping (T) -> Void) {
        
        var urlComponent = URLComponents(string: url)
        urlComponent?.queryItems = [
            URLQueryItem(name: "page_no", value: String(pageNumber)),
            URLQueryItem(name: "items_per_page", value: String(itemsPerPage))
        ]
        
        guard let urlComponentURL = urlComponent?.url else { return }
        
        let request = URLRequest(url: urlComponentURL)
        
        sendRequest(request, completion)
    }
    
    private func sendRequest<T: Decodable>(_ request: URLRequest, _ completion: @escaping (T) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            do {
                let data = try isData(data, response, error)
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(decodedData)
            } catch {
                print(error)
            }
        }
        task.resume()
    }
    
    private func isData(_ data: Data?, _ response: URLResponse?, _ error: Error?) throws -> Data {
        if let error = error {
            throw error
        }
        
        if let urlError = responseErrorhandling(response) {
            throw urlError
        }
        
        guard let data = data else {
            throw URLSessionError.invalidData
        }
        
        return data
    }

    private func responseErrorhandling(_ response: URLResponse?) -> URLSessionError? {
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
