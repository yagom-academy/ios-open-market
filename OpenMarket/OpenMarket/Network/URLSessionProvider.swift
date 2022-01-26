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
        let boundary = "\(UUID().uuidString)"
        guard let url = URL(string: RequestType.productRegistration.url()) else {
            return completionHandler(.failure(NetworkError.wrongURL))
        }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("f4363f92-71e8-11ec-abfa-17aac326b73f", forHTTPHeaderField: "identifier")
        request.httpBody = createBody(parameters: parameters, boundary: boundary, images: registImages)
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func createBody(parameters: ProductParam, boundary: String, images: [Data]) -> Data {
        var body = Data()
        guard let value = try? JSONEncoder().encode(parameters) else {
            return Data()
        }
        let boundaryPrefix = "--\(boundary)\r\n"
        
        body.append(string: boundaryPrefix)
        body.append(string: "Content-Disposition: form-data; name=\"params\"\r\n")
        body.append(string: "Content-Type: application/json\r\n")
        body.append(string: "\r\n")
        body.append(value)
        body.append(string: "\r\n")
        for image in images {
            body.append(string: boundaryPrefix)
            body.append(string: "Content-Disposition: form-data; name=\"images\"; filename=\"\(UUID().uuidString).jpeg\"\r\n")
            body.append(string: "Content-Type: image/jpeg)\r\n")
            body.append(string: "\r\n")
            body.append(image)
            body.append(string: "\r\n")
        }
        body.append(string: "--\(boundary)--\r\n")
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
