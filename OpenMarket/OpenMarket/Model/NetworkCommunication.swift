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
    var imageTask: URLSessionDataTask?
    
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
    
    mutating func requestImageData(url: URL,
                                   completionHandler: @escaping (Result<Data, APIError>) -> Void) {
        imageTask = session.dataTask(with: url) { data, response, error in
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
        imageTask?.resume()
    }
}

// MARK: -PostRequest
extension NetworkCommunication {
    func requestPostData(url: String,
                         images: [UIImage],
                         name: String,
                         description: String,
                         price: Int,
                         currency: Currency,
                         discountPrice: Int,
                         stock: Int,
                         secret: String,
                         completionHandler: @escaping (Result<String, APIError>) -> Void) {
        guard let url: URL = URL(string: url) else { return }
        let postRequestParams = PostRequestParams(name: name,
                                                  description: description,
                                                  secret: secret,
                                                  price: price,
                                                  discountedPrice: discountPrice,
                                                  stock: stock,
                                                  currency: currency)
        let urlRequest = generatePostRequest(url: url,
                                             images: images,
                                             params: postRequestParams)
        
        let task: URLSessionDataTask = session.dataTask(with: urlRequest) { _, response, error in
            if error != nil { return }
            
            if let response = response as? HTTPURLResponse {
                if !(200...299).contains(response.statusCode) {
                    print("POST CODE Error : <<\(response.statusCode)>>")
                    completionHandler(.failure(.statusCodeError))
                } else {
                    completionHandler(.success("POST CODE : \(response.statusCode)"))
                }
            }
        }
        task.resume()
    }
    
    func generatePostRequest(url: URL,
                             images: [UIImage],
                             params: PostRequestParams) -> URLRequest {
        
        let bodyData = multipartFormDataBody(images: images,
                                             params: params)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("70e4e3d7-6942-11ed-a917-6d2a7e9f7538", forHTTPHeaderField: "identifier")
        urlRequest.httpBody = bodyData
  
        return urlRequest
    }
    
    private func multipartFormDataBody(images: [UIImage],
                                       params: PostRequestParams) -> Data? {
        
        let postRequestParams = params
        guard let jsonParams = try? JSONEncoder().encode(postRequestParams) else { return nil }
        
        let lineBreak = "\r\n"
        var body = Data()
        
        body.append("--\(boundary + lineBreak)")
        body.append("Content-Disposition: form-data; name=\"params\" \(lineBreak + lineBreak)")
        body.append(jsonParams)
        body.append("\(lineBreak)")
        
        for image in images {
            if let imageData = compressQualityImage(image: image, value: 0.99) {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"images\"; filename=\"\(arc4random()).jpeg\" \(lineBreak)")
                body.append("Content-Type: image/jpeg \(lineBreak + lineBreak)")
                body.append(imageData)
                body.append("\(lineBreak)")
                print("데이터크기: \(imageData.count)bytes")
            }
        }
        body.append("--\(boundary)--")
        
        return body
    }
    
    private func compressQualityImage(image: UIImage, value: Double) -> Data? {
        guard let imageData = image.jpegData(compressionQuality: value) else { return nil }
        if imageData.count >= 300000 {
            return compressQualityImage(image: image, value: value - 0.01)
        }
        return imageData
    }
}
