import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSessionProtocol {
    func request(urlRequest: URLRequest, completion: @escaping (Result<Data, Error>) -> Void) {
        let task = dataTask(with: urlRequest) { (data, response, error) in
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
        }
        task.resume()
    }
}

