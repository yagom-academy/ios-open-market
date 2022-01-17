import UIKit

enum ImageLoader {
    static func load(from urlString: String, completion: @escaping (Result<Data, APIError>) -> ()) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(APIError.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(APIError.invalidResponse))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                completion(.failure(APIError.notProperStatusCode))
                return
            }
         
            completion(.success(data))
        }.resume()
    }
}
