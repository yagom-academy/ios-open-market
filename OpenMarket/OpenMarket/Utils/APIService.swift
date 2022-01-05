import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

class APIService {
    let session: URLSessionProtocol
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return decoder
    }()
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
    
    func retrieveProductData<T: Decodable>(request: URLRequest, completion: @escaping (Result<T, Error>) -> ()) {
        let task = session.dataTask(with: request) { data, response, error in
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
