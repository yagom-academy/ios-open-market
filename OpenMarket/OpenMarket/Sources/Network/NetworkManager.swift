//
//  OpenMarket - NetworkManager.swift
//  Created by Zhilly, Dragon. 22/11/15
//  Copyright © yagom. All rights reserved.
//

import Foundation
import UIKit

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

extension NetworkManager: NetworkPostable {
    func post(to url: URL?) {
        let boundary: String = "Boundary-\(UUID().uuidString)"
        guard let targetURL: URL = url else { return }
        var request: URLRequest = URLRequest(url: targetURL)
        
        request.httpMethod = HttpMethod.post.name
        request.setValue("f44cfc3e-6941-11ed-a917-47bc2e8f559b", forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpBody = buildBody(boundary: boundary)
        
        session.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8)!)
        }.resume()
    }
    
    func checkDeleteURI(to url: URL?, completion: @escaping (String) -> Void) {
        guard let targetURL: URL = url else { return }
        var request: URLRequest = URLRequest(url: targetURL)
        
        request.httpMethod = HttpMethod.post.name
        request.setValue("f44cfc3e-6941-11ed-a917-47bc2e8f559b", forHTTPHeaderField: "identifier")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = convertToJSONData()
        
        session.dataTask(with: request) { data, response, error in            
            if let data = data, let url = String(data: data, encoding: .utf8) {
                completion(url)
            }
        }.resume()
    }
    
    private func buildBody(boundary: String) -> Data {
        var httpBody = Data()
        guard let fakeData = try? JSONSerialization.data(withJSONObject: ["name": "두부",
                                                                          "description": "질리네강아지",
                                                                          "price": 999999999,
                                                                          "currency": "USD",
                                                                          "discounted_price": 0,
                                                                          "stock": 1,
                                                                          "secret": "rzeyxdwzmjynnj3f" ]) else {
            return Data()
        }
        let image = UIImage(named: "Dooboo.jpg")
        guard let imageData = image!.jpegData(compressionQuality: 0.1) else { return Data() }
        
        httpBody.append(convertDataForm(named: "params", value: fakeData, boundary: boundary))
        httpBody.append(convertFileDataForm(boundary: boundary,
                                            fieldName: "images",
                                            fileName: "Dooboo.png",
                                            mimeType: "multipart/form-data",
                                            fileData: imageData))
        httpBody.appendString("--\(boundary)--")
        
        return httpBody
    }
    
    private func convertDataForm(named name: String, value: Data, boundary: String) -> Data {
        var data = Data()
        
        data.appendString("--\(boundary)\r\n")
        data.appendString("Content-Disposition: form-data; name=\"\(name)\"\r\n")
        data.appendString("\r\n")
        data.append(value)
        data.appendString("\r\n")
        
        return data
    }
    
    private func convertFileDataForm(boundary: String,
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
    
    private func convertToJSONData() -> Data {
        var data = Data()
        guard let fakeData = try? JSONSerialization.data(withJSONObject: ["secret": "rzeyxdwzmjynnj3f"]) else {
            return Data()
        }
        
        data.append(fakeData)
        
        return data
    }
}

extension NetworkManager: NetworkPatchable {
    func patch(to url: URL?) {
        guard let targetURL: URL = url else { return }
        var request: URLRequest = URLRequest(url: targetURL)
        
        request.httpMethod = HttpMethod.patch.name
        request.setValue("f44cfc3e-6941-11ed-a917-47bc2e8f559b", forHTTPHeaderField: "identifier")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = buildData()
        
        session.dataTask(with: request) { data, response, error in
            print(String(data: data!, encoding: .utf8)!)
        }.resume()
    }
    
    private func buildData() -> Data {
        var data = Data()
        guard let fakeData = try? JSONSerialization.data(withJSONObject: ["stock": 1,
                                                                          "name": "두부",
                                                                          "description": "질리네강아지",
                                                                          "price": 9999999999,
                                                                          "currency": "USD",
                                                                          "discounted_price": 0,
                                                                          "secret": "rzeyxdwzmjynnj3f" ]) else {
            return Data()
        }
        
        data.append(fakeData)
        
        return data
    }
}
