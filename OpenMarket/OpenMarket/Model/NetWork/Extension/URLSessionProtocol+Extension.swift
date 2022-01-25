import Foundation

protocol URLSessionProtocol {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSessionProtocol {
    func createURLRequest(requester: APIRequestable) throws -> URLRequest {
        guard let url = requester.url else {
            throw APIError.URLConversionFail
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requester.httpMethod.rawValue
        
        if let httpBody = requester.httpBody {
            request.httpBody = httpBody
        }
        
        if let headerFields = requester.headerFields {
            headerFields.forEach {
                request.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        
        return request
    }
    
    func request(requester: APIRequestable, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let urlRequest = try? createURLRequest(requester: requester) else {
            completion(.failure(APIError.URLConversionFail))
            return
        }

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

