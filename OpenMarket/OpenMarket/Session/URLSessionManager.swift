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
        return "https://market-training.yagom-academy.kr/api/products/\(productNumber)"
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
    
    private func makeBody(parameters: [[String : Any]], boundary: String) -> Data? {
        var body = Data()
        
        for param in parameters {
            guard let paramName = param["key"] as? String else { return nil }
            let paramType = param["type"] as? String
            
            guard let boundary = "--\(boundary)\r\n".data(using: .utf8),
                  let disposition = "Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8) else { return nil }
            if paramType == "text"{
                guard let paramValue = param["value"] as? String,
                      let value = "\r\n\r\n\(paramValue)\r\n".data(using: .utf8) else { return nil }
                
                body.append(contentsOf: boundary)
                body.append(contentsOf: disposition)
                body.append(contentsOf: value)
            } else {
                guard let imageParams = param["images"] as? [ImageParam] else { return nil }
                
                for param in imageParams {
                    guard let fileName = "; filename=\"\(param.imageName)\"\r\n".data(using: .utf8),
                          let contentType = "Content-Type: image/\(param.imageType)\r\n\r\n".data(using: .utf8),
                          let space = "\r\n".data(using: .utf8) else { return nil }
                    
                    body.append(contentsOf: boundary)
                    body.append(contentsOf: disposition)
                    body.append(contentsOf: fileName)
                    body.append(contentsOf: contentType)
                    body.append(contentsOf: param.imageData)
                    body.append(contentsOf: space)
                }
            }
        }
        
        guard let lastBoundary = "--\(boundary)--\r\n".data(using: .utf8) else { return nil }
        body.append(contentsOf: lastBoundary)
    
        return body
    }
    
    func postData(dataElement: [[String : Any]], completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = makeBody(parameters: dataElement, boundary: boundary)
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func patchData(productNumber: Int, dataElement: String, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        guard let postData = dataElement.data(using: .utf8) else { return }

        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productNumber)") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.httpMethod = "PATCH"
        request.httpBody = postData

        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func inquireSecretKey(vendorSecret: String, productNumber: Int, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let parameters = "{\"secret\": \"\(vendorSecret)\"}"
        guard let postData = parameters.data(using: .utf8) else { return }
        
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productNumber)/secret") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody = postData
        
        dataTask(request: request, completionHandler: completionHandler)
    }
    
    func deleteData(secretKey: Data, productNumber: Int, completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        guard let secretKey = String(data: secretKey, encoding: .utf8) else { return }
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productNumber)/" + secretKey) else { return }
        var request = URLRequest(url: url)
        
        request.addValue("\(VendorInfo.identifier)", forHTTPHeaderField: "identifier")
        request.httpMethod = "DELETE"
        
        dataTask(request: request, completionHandler: completionHandler)
    }
}
