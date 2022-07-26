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
    
    func makeBody(parameters: [[String : Any]], boundary: String) -> Data{
        var body = Data()
        
        for param in parameters {
            if param["disabled"] == nil {
                let paramName = param["key"]!
                
                body.append(contentsOf: ("--\(boundary)\r\n").data(using: .utf8)!)
                body.append(contentsOf: ("Content-Disposition:form-data; name=\"\(paramName)\"").data(using: .utf8)!)
                
                let paramType = param["type"] as! String
                if paramType == "text" {
                    let paramValue = param["value"] as! String
                    
                    body.append(contentsOf: "\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
                } else {
                    let imageData = UIImage(named: "바보전구")!
                    let paramSrc = param["src"] as! String
                    let fileData = imageData.jpegData(compressionQuality: 0.5)!
                    
                    body.append(contentsOf: ("; filename=\"\(paramSrc)\"\r\n").data(using: .utf8)!)
                    body.append(contentsOf: ("Content-Type: image/\(paramType)\r\n\r\n").data(using: .utf8)!)
                    body.append(contentsOf: fileData)
                    body.append(contentsOf: ("!\r\n").data(using: .utf8)!)
                }
            }
        }
        body.append(contentsOf: ("--\(boundary)--\r\n").data(using: .utf8)!)
        return body
    }
    
    func postData(completionHandler: @escaping (Result<Data, DataTaskError>) -> Void) {
        let parameters = [
            [
                "key": "params",
                "value": """
            {
            "name": "바보전구",
            "price": 29900,
            "stock": 10000,
            "currency": "KRW",
            "secret": "0hvvXjSeAS",
            "descriptions": "안녕하세요 바보전구입니다."
            }
""",
                "type": "text"
            ],
            [
                "key": "images",
                "src": "file:///Users/zzbae/Desktop/%E1%84%87%E1%85%A1%E1%84%87%E1%85%A9%E1%84%8C%E1%85%A5%E1%86%AB%E1%84%80%E1%85%AE.jpg",
                "type": "file"
            ]] as [[String : Any]]
        
        let boundary = "Boundary-\(UUID().uuidString)"
        var request = URLRequest(url: URL(string: "https://market-training.yagom-academy.kr/api/products")!)
        
        request.addValue("f27bc126-0335-11ed-9676-1776ba240ec2", forHTTPHeaderField: "identifier")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        request.httpBody =  makeBody(parameters: parameters, boundary: boundary)
        dataTask(request: request, completionHandler: completionHandler)
    }
}

