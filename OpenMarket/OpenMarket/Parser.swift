//
//  Parser.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/27.
//

import Foundation

struct Parser<T: Codable> {
    static func decodeJSONAPI(url: URL, result: @escaping (Result<T, Error>) -> ()) {
        APIManager.requestGET(url: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                result(.failure(<#T##NetworkingError#>))
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                result(.failure(<#T##NetworkingError#>))
            }
            
            guard let data = data else {
                result(.failure(<#T##NetworkingError#>))
            }
            
            do {
                let decodingResult = try JSONDecoder().decode(T.self, from: data)
                result(.success(decodingResult))
            } catch {
                result(.failure(error))
            }
        }
    }
    
    static func postToAPI(url: URL, data: T, result: @escaping (Error) -> ()) {
        guard let uploadData = try? JSONEncoder().encode(data) else {
            return
        }
        
        APIManager.requestPOST(url: url, uploadData: uploadData) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                result(<#T##NetworkingError#>)
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                result(<#T##NetworkingError#>)
            }
        }
    }
    
    static func deleteAPI(url: URL, result: @escaping (Result<T, Error>) -> ()) {
        APIManager.requestGET(url: url) { (data: Data?, response: URLResponse?, error: Error?) in
            guard error == nil else {
                result(.failure(<#T##NetworkingError#>))
            }

            guard let response = response as? HTTPURLResponse,
                  (200...299).contains(response.statusCode) else {
                result(.failure(<#T##NetworkingError#>))
            }
            
            guard let data = data else {
                result(.failure(<#T##NetworkingError#>))
            }
            
        }
    }
}

