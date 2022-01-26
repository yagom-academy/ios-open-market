import Foundation
import UIKit

class URLSessionProvider {
    let session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, NetworkError>) -> Void) {
        let task = session.dataTask(with: request) { data, urlResponse, error in
            // 확인용
            print("data: \(String(data: data!, encoding: .utf8))")
            print("error: \(error)")
            print((urlResponse as! HTTPURLResponse).statusCode)
            
            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                return completionHandler(.failure(.urlResponseError))
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
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
    func postData(requestType: PostType, params: ProductParams, images: [UIImage], completionHandler: @escaping (Result<Data, NetworkError>) -> Void)  {
        guard let url = URL(string: requestType.url(type: requestType)) else {
            return completionHandler(.failure(NetworkError.wrongURL))
        }
        
        let imageFiles = convertImagesToFiles(with: images)
        
        var request: URLRequest
        let boundary = "\(UUID().uuidString)"
        
        request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = createBody(params: params, boundary: boundary, images: imageFiles)
        request.addValue("bd4fb57f-7215-11ec-abfa-957fdcf7de42",
                         forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\"\(boundary)\"",
                         forHTTPHeaderField: "Content-Type")
        
        // 확인용
        print("httpBody: \(request.httpBody ?? Data())")
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func createBody(params: ProductParams, boundary: String, images: [ImageFile]) -> Data {
        var body = Data()
        var encodedData = Data()
        
        switch jsonEncoder(data: params) {
        case .success(let data):
            encodedData = data
        case .failure(let error):
            print(error)
        }
        
        // 테스트용
        print("JSON: \(String(data: encodedData, encoding: .utf8))")
        
        body.append(string: "--\(boundary)\r\n")
        body.append(string: "Content-Disposition: form-data; name=\"params\"\r\n")
        body.append(string: "Content-Type: application/json\r\n\r\n")
        body.append(encodedData)
        body.append(string: "\r\n")
        
        //        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        
        for image in images {
            body.append(string: "--\(boundary)\r\n")
            body.append(string: "Content-Disposition: form-data; name=\"images\"; filename=\"\(image.fileName)\"\r\n")
            body.append(string: "Content-Type: image/png\r\n\r\n")
            body.append(image.data)
            body.append(string: "\r\n")
        }
        
        body.append(string: "--\(boundary)--\r\n")
        
        return body
    }
    
    func convertImagesToFiles(with images: [UIImage]) -> [ImageFile] {
        var imageFiles = [ImageFile]()
        let imageType = "png"
        
        images.forEach { image in
            guard let imagePNG = image.pngData() else {
                return
            }
            
            let fileName = UUID().uuidString
            let imageFile = ImageFile(fileName: "\(fileName).\(imageType)", data: imagePNG, type: imageType)
            
            imageFiles.append(imageFile)
        }
        
        return imageFiles
    }
    
    func jsonEncoder(data: ProductParams) -> Result<Data, NetworkError> {
        let encoder = JSONEncoder()
        
        guard let data = try? encoder.encode(data) else {
            return .failure(.parsingFailed)
        }
        
        return .success(data)
    }
}
