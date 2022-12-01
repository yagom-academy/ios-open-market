//
//  NetworkCommunication.swift
//  OpenMarket
//
//  Created by Mangdi, Woong on 2022/11/16.
//

import Foundation
import UIKit

struct NetworkCommunication {
    let session = URLSession(configuration: .default)
    let boundary = "boundary-\(UUID().uuidString)"
    
    func requestHealthChecker(
        url: String,
        completionHandler: @escaping (Result<HTTPURLResponse, APIError>) -> Void
    ) {
        guard let url: URL = URL(string: url) else {
            completionHandler(.failure(.wrongUrlError))
            return
        }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { _, response, error in
            if error != nil {
                completionHandler(.failure(.unkownError))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("URL요청 실패 : 코드\(response.statusCode)")
                    completionHandler(.failure(.statusCodeError))
                    return
                }
                completionHandler(.success(response))
            }
        }
        task.resume()
    }
    
    func requestProductsInformation<T: Decodable>(
        url: String,
        type: T.Type,
        completionHandler: @escaping (Result<T, APIError>) -> Void
    ) {
        guard let url: URL = URL(string: url) else {
            completionHandler(.failure(.wrongUrlError))
            return
        }
        
        let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.unkownError))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("URL요청 실패 : 코드\(response.statusCode)")
                    completionHandler(.failure(.statusCodeError))
                    return
                }
            }
            
            if let data = data {
                do {
                    let decodingData = try JSONDecoder().decode(type.self, from: data)
                    completionHandler(.success(decodingData))
                } catch {
                    completionHandler(.failure(.jsonDecodingError))
                }
            }
        }
        task.resume()
    }
    
    func requestImageData(url: URL, completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        let task: URLSessionDataTask = session.dataTask(with: url) { data, response, error in
            if error != nil {
                completionHandler(.failure(.unkownError))
                return
            }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("URL요청 실패 : 코드\(response.statusCode)")
                    completionHandler(.failure(.statusCodeError))
                    return
                }
            }
            
            if let data = data {
                completionHandler(.success(data))
            } else {
                completionHandler(.failure(.imageDataConvertError))
            }
        }
        task.resume()
    }
}

// MARK: -PostRequest
extension NetworkCommunication {
    func requestPostData(url: String) {
        guard let url: URL = URL(string: url) else { return }
        let urlRequest = generatePostRequest(url: url)
        let task: URLSessionDataTask = session.dataTask(with: urlRequest) { data, response, error in
            if error != nil { return }
            
            if let response = response as? HTTPURLResponse {
                print("POST CODE : <<\(response.statusCode)>>") // 수정요망!!<<<<--------
            }
        }
        task.resume()
    }
    
    func generatePostRequest(url: URL) -> URLRequest {
        var urlRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("0d3776e1-6942-11ed-a917-1925ee1c13db", forHTTPHeaderField: "identifier")
        urlRequest.httpBody = multipartFormDataBody()
        
        let str = String(decoding: multipartFormDataBody(), as: UTF8.self)
        print(str) // 수정요망!!<<<<--------
        
        return urlRequest
    }
    
    private func multipartFormDataBody() -> Data {
        let cloudImage: UIImage = UIImage(systemName: "cloud")!
        let carImage: UIImage = UIImage(systemName: "car")!
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"params\" \(lineBreak + lineBreak)")
        body.append("{ \"name\": \"testtest\", \"description\": \"t1t1t1\", \"price\": 10000, \"currency\": \"KRW\", \"discounted_price\": 500, \"stock\": 1, \"secret\": \"pdb9mscczgcyt7wr\" }")
        body.append("\(lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"images\"; filename=\"one.jpeg\" \(lineBreak)")
        body.append("Content-Type: image/jpeg")
        body.append("\(lineBreak + lineBreak)")
        body.append(cloudImage.jpegData(compressionQuality: 0.99)!)
        body.append("\(lineBreak)")
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"images\"; filename=\"two.jpeg\" \(lineBreak)")
        body.append("Content-Type: image/jpeg")
        body.append("\(lineBreak + lineBreak)")
        body.append(carImage.jpegData(compressionQuality: 0.99)!)
        body.append("\(lineBreak)")
        
        body.append("--\(boundary)--")
        
        return body
    }
}
