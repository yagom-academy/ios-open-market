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
                      print("ERRORCODE:\(String(describing: urlResponse))")
                      return completionHandler(.failure(.statusCodeError))
                  }
            
            guard let data = data else {
               return completionHandler(.failure(.emptyValue))
            }
            completionHandler(.success(data))
        }
        task.resume()
    }
    
    func getData(requestType: GetType, completionHandler: @escaping (Result<Data, NetworkError>) -> Void)  {
        guard let url = URL(string: requestType.url(type: requestType)) else {
            return completionHandler(.failure(NetworkError.wrongURL))
        }
        
        var request: URLRequest
        
        request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}
