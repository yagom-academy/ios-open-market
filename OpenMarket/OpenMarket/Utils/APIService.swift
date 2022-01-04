import Foundation

class APIService {
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    func retrieveProductData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> ()) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200..<300).contains(httpResponse.statusCode) else {
                      print(error?.localizedDescription)
                      return
                  }
            
            if let data = data {
                do {
                    let parsedData = try self.decoder.decode(T.self, from: data)
                    completion(.success(parsedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
