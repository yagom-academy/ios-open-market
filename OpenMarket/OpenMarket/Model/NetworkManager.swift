//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/13.
//

import Foundation

enum RequestType: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    case patch = "PATCH"
    
    var method: String {
        return self.rawValue
    }
}

enum NetworkError: Error {
    case invalidHandler
    case invalidURL
    case failResponse
    case invalidData
    case unownedError
}

protocol Networkable {
    func dataTask(with request: URLRequest, completionHandler: @escaping(Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: Networkable {}

typealias URLSessionResult = ((Result<Data, NetworkError>) -> Void)

class NetworkManager {
    private let parsingManager = ParsingManager()
    private let session: Networkable
    
    init(session: Networkable = URLSession.shared) {
        self.session = session
    }
    
    func request<T: APIModelProtocol>(requsetType: RequestType, url: String, model: T?, completion: @escaping URLSessionResult) {
        
        guard let url = URL(string: url) else {
            return completion(.failure(NetworkError.invalidURL))
        }
        
        var request = URLRequest(url: url)
        
        switch requsetType {
        case .get:
            request.httpMethod = requsetType.method
        case .patch, .post:
            request.httpMethod = requsetType.method
            guard let model = model else {
                //body 안들어오는 에러처리
                return
            }
            let body = createDataBody(model: model)
            request.httpBody = body
            request.setValue("multipart/form-data; boundary=\(ParsingManager.boundary)", forHTTPHeaderField: "Content-Type")
        case .delete:
            request.httpMethod = requsetType.method
            guard let model = model else { return }
            let body = parsingManager.encodingModel(model: model)
            request.httpBody = body
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                completion(.failure(NetworkError.unownedError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkError.failResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.invalidData))
                return
            }
            completion(.success(data))
        } .resume()
    }
}

extension NetworkManager {
    private func createDataBody<T: APIModelProtocol>(model: T) -> Data? {
        var body = Data()
        let lineBreak = "\r\n"
        
        if let model = model as? MultiPartFormProtocol {
            for (key, value) in model.textField {
                body.append(convertTextField(key: key, value: value ?? ""))
            }
            guard let modelImages = model.mediaFile else {
                body.append("--\(ParsingManager.boundary)--\(lineBreak)")
                return body
            }
            for image in modelImages {
                body.append(convertFileField(key: image.key, source: image.filename, mimeType: image.mimeType, value: image.data))
            }
            body.append("--\(ParsingManager.boundary)--\(lineBreak)")
        } else {
            if let data = parsingManager.encodingModel(model: model) {
                body = data
            }
        }
        print(String(decoding: body, as: UTF8.self))
        return body
    }
    
    private func convertFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
        let lineBreak = "\r\n"
        var dataField = Data()
        
        
        dataField.append("--\(ParsingManager.boundary + lineBreak)")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\(lineBreak)")
        dataField.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
        dataField.append(value)
        dataField.append(lineBreak)
        
        return dataField
    }
    
    private func convertTextField(key: String, value: String) -> Data {
        let lineBreak = "\r\n"
        var textField = Data()
        
        textField.append("--\(ParsingManager.boundary + lineBreak)")
        textField.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
        textField.append("\(value)\(lineBreak)")
        
        return textField
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}

