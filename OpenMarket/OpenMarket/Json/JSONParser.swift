//
//  JSONParser.swift
//  OpenMarket
//
//  Created by BaekGom, Brad on 2022/07/12.
//

import Foundation
import QuartzCore

class JSONParser {
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared){
        self.session = session
    }
    
    func dataTask(by url: String, completion: @escaping (Result<ProductListResponse, CustomError>) -> ()) {
        guard let url = URL(string: url) else {
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(CustomError.statusCodeError))
            }
            
            if let data = data {
                do {
                    let decodeData = try JSONDecoder().decode(ProductListResponse.self, from: data)
                    completion(.success(decodeData))
                }
                catch {
                    print(error.localizedDescription)
                }
            }
        }
        task.resume()
    }
}

protocol URLSessionProtocol {
    func dataTask(with request: URLRequest,completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol { }
