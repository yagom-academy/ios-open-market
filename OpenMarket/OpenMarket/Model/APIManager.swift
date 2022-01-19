import Foundation
import UIKit

typealias Parameters = [String: String]

class APIManager {
    
    let boundary = "Boundary-\(UUID().uuidString)"
    let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    func checkAPIHealth(completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URLManager.healthChecker.url else { return }
        let request = URLRequest(url: url, method: .get)
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode >= 300 {
                completion(.failure(URLSessionError.responseFailed(code: httpResponse.statusCode)))
                return
            }
            
            if let error = error {
                completion(.failure(URLSessionError.requestFailed(description: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLSessionError.invaildData))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
    
    func checkProductDetail(id: Int, completion: @escaping (Result<ProductDetail, Error>) -> Void) {
        guard let url = URLManager.checkProductDetail(id: id).url else { return }
        let request = URLRequest(url: url, method: .get)
        createDataTask(with: request, completion: completion)
    }
    
    func checkProductList(pageNumber: Int, itemsPerPage: Int, completion: @escaping (Result<ProductList, Error>) -> Void) {
        guard let url = URLManager.checkProductList(pageNumber: pageNumber, itemsPerPage: itemsPerPage).url else { return }
        let request = URLRequest(url: url, method: .get)
        createDataTask(with: request, completion: completion)
    }
    
}

extension APIManager {
    
    func createParams(with modelData: NewProduct) -> Parameters? {
        guard let parameterBody = JSONParser.encodeToDataString(with: modelData) else { return nil }
        let params: Parameters = ["params": parameterBody]
        return params
    }
    
    func createDataBody(withParameters params: Parameters?, images: [NewProductImage]?) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value)\(lineBreak)")
            }
        }

        if let images = images {
            for image in images {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(image.key)\"; filename=\"\(image.fileName)\"\(lineBreak)")
                body.append("Content-Type: image/jpeg, image/jpg, image/png\(lineBreak + lineBreak)")
                body.append(image.image)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}

extension APIManager {
    
    func createDataTask<T: Decodable>(with request: URLRequest, completion: @escaping (Result<T, Error>) -> Void) {
        let task = urlSession.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse,
               httpResponse.statusCode >= 300 {
                completion(.failure(URLSessionError.responseFailed(code: httpResponse.statusCode)))
                return
            }
            
            if let error = error {
                completion(.failure(URLSessionError.requestFailed(description: error.localizedDescription)))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLSessionError.invaildData))
                return
            }
            guard let decodedData = JSONParser.decodeData(of: data, type: T.self) else {
                completion(.failure(JSONError.dataDecodeFailed))
                return
            }
            completion(.success(decodedData))
        }
        task.resume()
    }
    
}
