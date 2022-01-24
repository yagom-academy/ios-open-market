import Foundation
import UIKit

class URLSessionProvider {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            print(String(data: data!, encoding: .utf8))
            guard let httpResponse = urlResponse as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                      return completionHandler(.failure(.statusCodeError))
                  }
            
            guard let data = data else {
                return completionHandler(.failure(.unknownFailed))
            }
            
            completionHandler(.success(data))
        }
        
        task.resume()
    }
}

// MARK: httpMethod "GET"
extension URLSessionProvider {
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

// MARK: httpMethod "POST"
extension URLSessionProvider {
    func postData(requestType: PostType, params: [String: ProductParams], images: [UIImage], completionHandler: @escaping (Result<Data, NetworkError>) -> Void)  {
        guard let url = URL(string: requestType.url(type: requestType)) else {
            return completionHandler(.failure(NetworkError.wrongURL))
        }
        
        let imageFiles = convertImagesToFiles(with: images)
        
        var request: URLRequest
        let boundary = "Boundary-\(UUID().uuidString)"
        
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\(boundary)",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("cd706a3e-66db-11ec-9626-796401f2341a",
                         forHTTPHeaderField: "identifier")
        request.httpBody = createBody(params: params, boundary: boundary, images: imageFiles)
                
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func createBody(params: [String: ProductParams], boundary: String, images: [ImageFile]) -> Data {
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in params {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        body.append(boundaryPrefix.data(using: .utf8)!)
        
        for image in images {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(image.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/\(image.type)\r\n\r\n".data(using: .utf8)!)
            body.append(image.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    func convertImagesToFiles(with images: [UIImage]) -> [ImageFile] {
        var imageFiles = [ImageFile]()
        
        images.enumerated().forEach { (index, image) in
            guard let imagePNG = image.pngData() else {
                return
            }
            
            let imageFile = ImageFile(fileName: "\(index).png", data: imagePNG, type: "png")
            imageFiles.append(imageFile)
        }
        
        return imageFiles
    }
}
