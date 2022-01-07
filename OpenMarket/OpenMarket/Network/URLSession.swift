import Foundation

class URLSessionProvider {
    let session: URLSessionProtocol
    let baseURL = "https://market-training.yagom-academy.kr/"
    
    init(session: URLSessionProtocol = URLSession.shared) {
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
    
    func getPage(id: Int, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}
