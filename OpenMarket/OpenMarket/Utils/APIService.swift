import Foundation

class APIService {
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
                    let parsedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(parsedData))
                } catch {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
}
