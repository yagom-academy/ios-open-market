//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Eddy, marisol on 2022/05/10.
//

import UIKit

enum NetworkError: Error {
    case error
    case data
    case statusCode
    case decode
}

struct ImageInfo {
    let fileName: String
    let data: Data
    let type: String
}

struct NetworkManager<T: Decodable> {
    var session: URLSessionProtocol
    var imageData: UIImage?
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    mutating func execute(with api: APIable, params: ProductToEncode? = nil, images: [ImageInfo]? = nil, completion: @escaping (Result<T, NetworkError>) -> Void) {
        let successRange = 200...299
        
        switch api.method {
        case .get:
            session.dataTask(with: api) { response in
                guard response.error == nil else {
                    completion(.failure(.error))
                    return
                }
                
                guard successRange.contains(response.statusCode) else {
                    completion(.failure(.statusCode))
                    return
                }
                
                guard let data = response.data else {
                    completion(.failure(.data))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(.decode))
                }
            }       
        case .post:
            guard let params = params,
                  let images = images else {
                      return
                  }

            request(url:api, params: params, images: images)
        case .put:
            print("put")
        case .delete:
            print("delete")
        }
    }
    
    mutating func request(url: APIable, params: ProductToEncode, images: [ImageInfo]) {
        let urlString = url.hostAPI + url.path
        guard let url = URL(string: urlString) else {
            return
        }
        
        let test = ProductToEncode(name: "test", descriptions: "desc", price: 123455, currency: .KRW, discountedPrice: 123, stock: 2122, secret: "password")
        
        let boundary = generateBoundary()
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\"\(boundary)\"",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("dbc73b2c-d1b7-11ec-9676-f1b4483156c1", forHTTPHeaderField: "identifier")
        request.httpBody = createBody(requestInfo: test, images: images, boundary: boundary)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            print(String(data: data!, encoding: .utf8))
            guard error == nil else {
                return
            }
            
            guard let _ = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 300) ~= response.statusCode else {
                return
            }
            
        }.resume()
    }
    
    func generateBoundary() -> String {
        return "\(UUID().uuidString)"
    }
    
    func createBody(requestInfo: ProductToEncode, images: [ImageInfo], boundary: String) -> Data? {
        var body: Data = Data()
                        
        guard let jsonData = try? JSONEncoder().encode(requestInfo) else {
            print("encoding error")
            return nil
        }
        
        body.append(convertDataToMultiPartForm(value: jsonData, boundary: boundary))
        body.append(convertFileToMultiPartForm(imageInfo: images, boundary: boundary))
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    func convertDataToMultiPartForm(value: Data, boundary: String) -> Data {
        var data: Data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"params\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: application/json\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        data.append(value)
        data.append("\r\n".data(using: .utf8)!)
        
        return data
    }
    
    func convertFileToMultiPartForm(imageInfo: [ImageInfo], boundary: String) -> Data {
        var data: Data = Data()
        for imageInfo in imageInfo {
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(imageInfo.fileName)\"\r\n".data(using: .utf8)!)
            data.append("Content-Type: \(imageInfo.type.description)\r\n".data(using: .utf8)!)
            data.append("\r\n".data(using: .utf8)!)
            data.append(imageInfo.data)
            data.append("\r\n".data(using: .utf8)!)
        }
        
        return data
    }
}
