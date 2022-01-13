import Foundation

class URLSessionProvider {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      return completionHandler(.failure(.statusCodeError))
                  }
            
            if let data = data {
                return completionHandler(.success(data))
            }
            
            completionHandler(.failure(.unknownFailed))
        }
        
        task.resume()
    }
    
    func getData(requestType: RequestType, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) throws {
        guard let url = URL(string: requestType.url(type: requestType)) else {
            throw NetworkError.wrongURL
        }
        
        var request: URLRequest
        
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}
