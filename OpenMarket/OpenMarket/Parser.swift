//
//  Parser.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/27.
//

import Foundation

struct Parser<T: Codable> {
    typealias ResultHandling = (Result<T, Error>) -> ()
    typealias ErrorHandling = (Error) -> ()
    
    static func decodeData(url: URL, result: @escaping ResultHandling) {
        APIManager.requestGET(url: url) { (data: Data?, response: URLResponse?, error: Error?) in
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
            
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                result(.success(decodedData))
            } catch {
                result(.failure(error))
            }
        }
    }
    
    static func postData(url: URL, object: T, result: @escaping ErrorHandling) {
        guard let encodedData = try? JSONEncoder().encode(object) else {
            result(NetworkingError.failedEncoding)
            return
        }
        
        APIManager.requestPOST(url: url, uploadData: encodedData) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                result(NetworkingError.failedRequest)
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                result(NetworkingError.failedResponse)
                return
            }
            
            if data == nil {
                result(NetworkingError.noData)
                return
            }
        }
    }
    
    static func patchData(url: URL, object: T, result: @escaping ErrorHandling) {
        guard let encodedData = try? JSONEncoder().encode(object) else {
            result(NetworkingError.failedEncoding)
            return
        }
        
        APIManager.requestPOST(url: url, uploadData: encodedData) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                result(NetworkingError.failedRequest)
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                result(NetworkingError.failedResponse)
                return
            }
            
            if data == nil {
                result(NetworkingError.noData)
                return
            }
        }
    }
    
    static func deleteData(url: URL, object: T, result: @escaping ErrorHandling) {
        guard let encodedData = try? JSONEncoder().encode(object) else {
            result(NetworkingError.failedEncoding)
            return
        }
        
        APIManager.requestDELETE(url: url, deleteData: encodedData) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                result(NetworkingError.failedRequest)
                return
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                result(NetworkingError.failedResponse)
                return
            }
            
            if data == nil {
                result(NetworkingError.noData)
                return
            }
        }
    }
}

