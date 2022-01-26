import Foundation

class URLSessionProvider {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) -> URLSessionDataTask {
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
        return task
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
    
    func postData(parameters: ProductParam, registImages: [Data],
                  completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: RequestType.productRegistration.url()) else {
            return completionHandler(.failure(NetworkError.wrongURL))
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        request.setValue("multipart/form-data; boundary\(boundary)", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = createBody(parameters: parameters, boundary: boundary, images: registImages)
        
        print(request)
        dataTask(request: request, completionHandler: completionHandler)
        
    }
    
    func createBody(parameters: ProductParam, boundary: String, images: [Data]) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
      
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"params\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(parameters)\r\n".data(using: .utf8)!)
            
        
        
        for image in images {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append(string: "Content-Disposition: form-data; name=\"images\"; filename=\"\(UUID().uuidString).jpeg\"")
            body.append(string: "Content-Type: image/jpeg)\r\n\r\n")
//            body.append(image.type.data(using: .utf8)!)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}

extension Data {
    mutating func append(string: String) {
        guard let data = string.data(using: .utf8) else {
            return
        }
        self.append(data)
    }
}
