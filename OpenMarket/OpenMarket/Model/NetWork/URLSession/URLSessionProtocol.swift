import Foundation

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
    func dataTask(with url: URL,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

//MARK: - Opened Method
extension URLSessionProtocol {
    func requestDataTask(urlString: String,
                         httpMethod: String,
                         httpBody: Data?,
                         headerFields: [String: String]?,
                         completion: @escaping (Result<Data, NetworkingAPIError>) -> Void) {
        
        guard let request = makeURLRequest(urlString: urlString,
                                           httpMethod: httpMethod,
                                           httpBody: httpBody,
                                           headerFields: headerFields) else {
            
            completion(.failure(.URLRequestMakingFail))
            return
        }
        
        dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.receivedInvalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.receivedIinvalidResponse))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                completion(.failure(.receivedFailureStatusCode))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
    
    func requestDataTask(url: URL, completion: @escaping (Result<Data, NetworkingAPIError>) -> Void) {
        dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                completion(.failure(.receivedInvalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(.receivedIinvalidResponse))
                return
            }
            
            guard (200...299) ~= response.statusCode else {
                completion(.failure(.receivedFailureStatusCode))
                return
            }
            
            completion(.success(data))
        }.resume()
    }
}

//MARK: - closed Method
extension URLSessionProtocol {
    private func makeURLRequest(urlString: String,
                    httpMethod: String,
                    httpBody: Data?,
                    headerFields: [String: String]?) -> URLRequest? {
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        if let headerFields = headerFields {
            headerFields.forEach {
                request.addValue($0.value, forHTTPHeaderField: $0.key)
            }
        }
        
        return request
    }
}
