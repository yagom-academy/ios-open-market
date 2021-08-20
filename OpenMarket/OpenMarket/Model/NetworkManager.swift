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
    case missMatchModel
    case invalidMethod
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

typealias URLSessionResult = ((Result<Data, Error>) -> Void)

class NetworkManager {
    static let baseUrl = "https://camp-open-market-2.herokuapp.com/"
    private let boundary = "Boundary-\(UUID().uuidString)"
    private let parsingManager = ParsingManager()
    private let session: Networkable
    
    init(session: Networkable = URLSession.shared) {
        self.session = session
    }
    
    func request(requsetType: RequestType, url: String, completion: @escaping URLSessionResult) {
        guard let url = URL(string: url) else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        if requsetType == .get {
            request.httpMethod = requsetType.method
        } else {
            completion(.failure(NetworkError.invalidMethod))
        }
        
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
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
    
    private func convertFileField(key: String, source: String, mimeType: String, value: Data) -> Data {
        let lineBreak = "\r\n"
        var dataField = Data()
        
        dataField.append("--\(boundary + lineBreak)")
        dataField.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(source)\"\(lineBreak)")
        dataField.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
        dataField.append(value)
        dataField.append(lineBreak)
        
        return dataField
    }
    
    private func convertTextField(key: String, value: String) -> Data {
        let lineBreak = "\r\n"
        var textField = Data()
        
        textField.append("--\(boundary + lineBreak)")
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

