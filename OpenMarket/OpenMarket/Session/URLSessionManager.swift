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
    
    private func makeBody(parameters: [[String : String]], boundary: String) -> Data {
        var body = Data()
        
        for param in parameters {
            let paramName = param.bringValue(key: "key")
            body.append(contentsOf: "--\(boundary)\r\n".convertData)
            body.append(contentsOf: "Content-Disposition:form-data; name=\"\(paramName)\"".convertData)
            
            let paramType = param.bringValue(key: "type")
            
            if paramType == "text" {
                let paramValue = param.bringValue(key: "value")
                body.append(contentsOf: "\r\n\r\n\(paramValue)\r\n".convertData)
                
            } else {
                let paramSrc = param.bringValue(key: "src")
                
                guard let imageData = UIImage(named: "제다이"),
                      let fileData = imageData.jpegData(compressionQuality: 0.5) else { return Data() }
                
                body.append(contentsOf: "; filename=\"\(paramSrc)\"\r\n".convertData)
                body.append(contentsOf: "Content-Type: image/\(paramType)\r\n\r\n".convertData)
                body.append(contentsOf: fileData)
                body.append(contentsOf: "\r\n".convertData)
            }
        }
        
        body.append(contentsOf: ("--\(boundary)--\r\n").convertData)
    
        return body
    }
    
    func postData(completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let parameters: [[String : String]] = [
            [
                "key": "params",
                "value": """
                        {
                            "name": "제다이",
                            "price": 20000,
                            "stock": 2,
                            "currency": "USD",
                            "secret": "0hvvXjSeAS",
                            "descriptions": "제다이 마스터입니다. (주디 & 재재)"
                        }
                        """,
                "type": "text"
            ],
            [
                "key": "images",
                "src": "file:///Users/kimjuyoung/Downloads/%E1%84%8C%E1%85%A6%E1%84%83%E1%85%A1%E1%84%8B%E1%85%B5.png",
                "type": "png"
            ]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let url = URL(string: "https://market-training.yagom-academy.kr/api/products") else { return }
        var request = URLRequest(url: url)
        
        request.addValue("f27bc126-0335-11ed-9676-1776ba240ec2", forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody =  makeBody(parameters: parameters, boundary: boundary)
        
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

extension Dictionary where Key == String, Value == String {
    fileprivate func bringValue(key: String) -> String {
        guard let value = self[key] else {
            return ""
        }
        
        return value
    }
}
