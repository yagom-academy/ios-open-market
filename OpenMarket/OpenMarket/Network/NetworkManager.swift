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
    
    mutating func execute(with api: APIable, completion: @escaping (Result<T, NetworkError>) -> Void) {
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
            guard let url = URL(string: "https://user-images.githubusercontent.com/52434820/170450737-7b947b6b-6b14-462a-8166-fa907c382437.jpg") else {
                return
            }
            
            guard let data = try? Data(contentsOf: url) else {
                return
            }
            
            self.imageData = UIImage(data: data)
            
            let dummyImage = ImageInfo(fileName: "dummy.jpg", data: (imageData?.jpegData(compressionQuality: 0.8))!, type: "jpg")
            
            let boundary = generateBoundary()
            
            request(url: api.hostAPI + api.path, image: dummyImage, boundary: boundary)
        case .put:
            print("put")
        case .delete:
            print("delete")
        }
    }
    
    func request(url: String, image: ImageInfo, boundary: String) {
        guard let url = URL(string: url) else {
            return
        }
        
        let requestInfo = Products(id: 1, vendorId: 2, name: "eddy", thumbnail: url, currency: "KRW", price: 1234567, descriptions: "desc", bargainPrice: 10, discountedPrice: 1234557, stock: 123, createdAt: nil, issuedAt: nil, secret: "password")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("multipart/form-data; boundary=\"\(boundary)\"",
                         forHTTPHeaderField: "Content-Type")
        request.addValue("cd706a3e-66db-11ec-9626-796401f2341a", forHTTPHeaderField: "identifier")
        request.httpBody = createBody(requestInfo: requestInfo, image: image, boundary: boundary)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
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
    
    func createBody(requestInfo: Products, image: ImageInfo, boundary: String) -> Data? {
        var body: Data = Data()
                        
        guard let jsonData = try? JSONEncoder().encode(requestInfo) else {
            return nil
        }
        
        body.append(convertDataToMultiPartForm(value: jsonData, boundary: boundary))
        body.append(convertFileToMultiPartForm(imageInfo: image, boundary: boundary))
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
    
    func convertFileToMultiPartForm(imageInfo: ImageInfo, boundary: String) -> Data {
        var data: Data = Data()
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(imageInfo.fileName)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: \(imageInfo.type.description)\r\n".data(using: .utf8)!)
        data.append("\r\n".data(using: .utf8)!)
        data.append(imageInfo.data)
        data.append("\r\n".data(using: .utf8)!)
        
        return data
    }
}
