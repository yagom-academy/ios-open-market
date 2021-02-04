//
//  APIManager.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/25.
//

import Foundation

struct APIManager {
    typealias URLSessionHandling = (Data?, URLResponse?, Error?) -> Void
    typealias ResultDataHandling = (Result<Data, Error>) -> ()
    
    static func request(requestType: RequestType, result: @escaping ResultDataHandling) {
        do {
            try makeURLRequest(requestType: requestType) { data, response, error in
                guard error == nil else {
                    result(.failure(NetworkingError.failedRequest))
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    result(.failure(NetworkingError.failedResponse))
                    return
                }
                
                guard let data = data else {
                    result(.failure(NetworkingError.noData))
                    return
                }
                
                result(.success(data))
            }
        } catch {
            result(.failure(error))
        }
    }
    
    static private func makeURLRequest(requestType: RequestType, completionHandler: @escaping URLSessionHandling) throws {
        guard let url = requestType.url else {
            throw NetworkingError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = requestType.httpMethod.rawValue
        
        switch requestType {
        case .getPage, .getItem:
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
            
        case .post(let itme):
            let data = makeDataToUpload(item: itme)
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        
            URLSession.shared.uploadTask(with: request, from: data, completionHandler: completionHandler).resume()
            
        case .patch(_, let item):
            let data = makeDataToUpload(item: item)
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
        
            URLSession.shared.uploadTask(with: request, from: data, completionHandler: completionHandler).resume()
            
        case .delete(_, let item):
            let data = try? JSONEncoder().encode(item)
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = data
            
            URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
    
    static private func makeDataToUpload(item: ItemToUpdate) -> Data {
        let boundary = "-- OdongBoundary"
        let parameters = item.makeParameters()
        let imageList = item.makeImageListToUpload()
        var bodyData = Data()

        for (key, value) in parameters {
            bodyData.append(boundary.data(using: .utf8)!)
            bodyData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            bodyData.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        if let imageList = imageList {
            for i in imageList {
                bodyData.append(boundary.data(using: .utf8)!)
                bodyData.append("Content-Disposition: form-data; name=\"\(i.imageKey)\"; filename=\"\(i.fileName)\"\r\n".data(using: .utf8)!)
                bodyData.append("Content-Type: \(i.mimeType)\r\n\r\n".data(using: .utf8)!)
                bodyData.append(i.imageData)
                bodyData.append("\r\n".data(using: .utf8)!)
                bodyData.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
            }
        }
        
        return bodyData
    }
}
