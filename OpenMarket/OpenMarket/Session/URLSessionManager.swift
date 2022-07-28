//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/12.
//

import UIKit

enum DataTaskError: Error {
    case incorrectResponse
    case invalidData
}

struct SubURL {
    func pageURL(number: Int, countOfItems: Int) -> String {
        return "https://market-training.yagom-academy.kr/api/products?page_no=\(number)&items_per_page=\(countOfItems)"
    }
    
    func productURL(productNumber: Int) -> String {
        return "https://market-training.yagom-academy.kr//api/products/\(productNumber)"
    }
}

final class URLSessionManager {
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    private func dataTask(request: URLRequest, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        session.dataTask(with: request) { data, urlResponse, error in
            guard let response = urlResponse as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                return completionHandler(.failure(.incorrectResponse))
            }
            
            guard let data = data else {
                return completionHandler(.failure(.invalidData))
            }
            
            return completionHandler(.success(data))
        }.resume()
    }
    
    func receiveData(baseURL: String, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        guard let url = URL(string: baseURL) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    private func makeBody(parameters: [[String : Any]], boundary: String) -> Data {
        var body = Data()
        
        for param in parameters {
            let paramName = param.bringStringValue(key: "key")
            body.append(contentsOf: "--\(boundary)\r\n".convertData)
            body.append(contentsOf: "Content-Disposition:form-data; name=\"\(paramName)\"".convertData)
            
            let paramType = param.bringStringValue(key: "type")
            
            if paramType == "text"{
                let paramValue = param.bringStringValue(key: "value")
                body.append(contentsOf: "\r\n\r\n\(paramValue)\r\n".convertData)
            } else {
                let imageParams = param["images"] as? [ImageParam] ?? []
                
                for param in imageParams {
                    body.append(contentsOf: "; filename=\"\(param.imageName)\"\r\n".convertData)
                    body.append(contentsOf: "Content-Type: image/\(param.imageType)\r\n\r\n".convertData)
                    body.append(contentsOf: param.imageData)
                    body.append(contentsOf: "\r\n".convertData)
                }
            }
        }
        body.append(contentsOf: ("--\(boundary)--\r\n").convertData)
    
        return body
    }
    
    func postData(dataElement: [[String : Any]], completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody =  makeBody(parameters: dataElement, boundary: boundary)
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func patchData(completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let parameters = "{\n    \"secret\": \"\(VendorInfo.secret)\",\n    \"discounted_price\": 10000\n}"
        let postData = parameters.convertData

        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/3946") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.httpMethod = "PATCH"
        request.httpBody = postData

        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func inquireSecretKey(completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let parameters = "{\"secret\": \"\(VendorInfo.secret)\"}"
        let postData = parameters.convertData
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/3943/secret") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func deleteData(secretKey: Data, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        guard let secretKey = String(data: secretKey, encoding: .utf8) else { return }
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/3943/" + secretKey) else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.httpMethod = "DELETE"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}

extension String {
    fileprivate var convertData: Data {
        guard let data = self.data(using: .utf8) else {
            return Data()
        }
        
        return data
    }
}

extension Dictionary where Key == String, Value == Any {
    fileprivate func bringStringValue(key: String) -> String {
        guard let value = self[key] else {
            return ""
        }
        
        return value as? String ?? ""
    }
    
    fileprivate func bringImageValue(key: String) -> UIImage {
        guard let value = self[key] else {
            return UIImage()
        }
        
        return value as? UIImage ?? UIImage()
    }
}
