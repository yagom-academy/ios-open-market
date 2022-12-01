//
//  OpenMarket - NetworkManager.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import Foundation

struct NetworkManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    private func dataTask<T: Decodable>(request: URLRequest,
                                        dataType: T.Type,
                                        completion: @escaping (Result<T, NetworkError>) -> Void) {
        let task: URLSessionDataTask = session.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(.failure(.dataTaskError))
            }
            
            if let serverResponse = response as? HTTPURLResponse {
                switch serverResponse.statusCode {
                case 100...101:
                    return completion(.failure(.informational))
                case 200...206:
                    break
                case 300...307:
                    return completion(.failure(.redirection))
                case 400...415:
                    return completion(.failure(.clientError))
                case 500...505:
                    return completion(.failure(.serverError))
                default:
                    return completion(.failure(.unknownError))
                }
            }
            
            guard let data = data else {
                return completion(.failure(.invalidData))
            }
            
            let decodedData = JSONDecoder.decodeData(data: data, to: dataType.self)
            
            if let data = decodedData {
                return completion(.success(data))
            } else {
                return completion(.failure(.parsingError))
            }
        }
        
        task.resume()
    }
}

extension NetworkManager: NetworkRequestable {
    func request<T: Decodable>(from url: URL?,
                               httpMethod: HttpMethod,
                               dataType: T.Type,
                               completion: @escaping (Result<T,NetworkError>) -> Void) {
        if let targetURL = url {
            var request: URLRequest = URLRequest(url: targetURL,timeoutInterval: Double.infinity)
            request.httpMethod = httpMethod.name
            
            dataTask(request: request, dataType: dataType, completion: completion)
        }
    }
}

extension NetworkManager {
    func post(from url: URL?) {
        //
    }
    
    func buildBody(with fileURL: URL?, fieldName: String) -> Data? {
        guard let fakeData = try? JSONSerialization.data(withJSONObject: ["name": "Smile",
                                                                          "description": "smile smile smile",
                                                                          "price": 18,
                                                                          "currency": "KRW",
                                                                          "discounted_price": 0,
                                                                          "stock": 8000,
                                                                          "secret": "rzeyxdwzmjynnj3f" ]) else { return Data() }
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var body = convertDataForm(named: "Smile", value: fakeData, boundary: boundary)
        body.append(convertFileDataForm(boundary: boundary,
                                                    fieldName: "images",
                                                    fileName: "Smile.png",
                                                    mimeType: "multipart/form-data",
                                                    fileData: fakeData))
        var data = body
        data.append(contentsOf: "\r\n--\(boundary)--".data(using:.utf8)!)
        print(String(data: data, encoding: .utf8)!)
        return data
    }
    
    func convertDataForm(named name: String, value: Data, boundary: String) -> Data {
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendString("\r\n")
        data.append(value)
        data.appendString("\r\n")
        return data
    }
    
    func convertFileDataForm(boundary: String,
                             fieldName: String,
                             fileName: String,
                             mimeType: String,
                             fileData: Data) -> Data {
        var data = Data()
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n")
        data.appendString("Content-Type: \(mimeType)\r\n\r\n")
        data.append(fileData)
        data.appendString("\r\n")
        return data
    }
}

extension Data {
    mutating func appendString(_ value: String) {
        guard let value = value.data(using: .utf8) else { return }
        self.append(value)
    }
}
