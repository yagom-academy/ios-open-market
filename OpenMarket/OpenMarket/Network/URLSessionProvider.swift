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
    
//    func postData(paramaeters: [String: Any], completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
//        let boundary = "Boundary-\(UUID().uuidString)"
//        guard let url = URL(string: RequestType.url(.productRegistration)) else {
//            return completionHandler(.failure(NetworkError.wrongURL))
//        }
//
//            var request = URLRequest(url: url)
//            request.httpMethod = "POST"
//
//        request.setValue("multipart/form-data; boundary\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpBody = createBody(paramaeters: p, boundary: <#T##String#>, images: <#T##[RegistImage]?#>)
//
//            dataTask(request: request, completionHandler: completionHandler)
//
//    }
//
//    func createBody(paramaeters: [String: Any], boundary: String, images: [RegistImage]?) -> Data {
//        var body = Data()
//        let boundaryPrefix = "--\(boundary)\r\n"
//
//        for (key, value) in paramaeters {
//            body.append(boundaryPrefix.data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//            body.append("\(value)\r\n".data(using: .utf8)!)
//
//        }
//        if let images = images {
//               for image in images {
//                 body.append(boundaryPrefix.data(using: .utf8)!)
//                 body.append("Content-Disposition: form-data; name=\"images[]\"; filename=\"\(image.key)\"\r\n".data(using: .utf8)!)
//                 body.append("Content-Type: image/\(image.src)\r\n\r\n".data(using: .utf8)!)
//                   body.append(image.type.data(using: .utf8))
//                 body.append("\r\n".data(using: .utf8)!)
//             }
//           }
//
//           body.append(boundaryPrefix.data(using: .utf8)!)
//        return body
//    }
    
//    [pram1: Any타입데이터]   //pram1은 ProductParams타입의 객체
    //Any타입데이터는 {"상품명": "맥북", "가격": "price ...}
    
    
}
