//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/20.
//

import Foundation

struct Network: NetworkAble {
    
    let session: URLSessionProtocol
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.session = session
    }
}

protocol NetworkAble {
    
    var session: URLSessionProtocol { get }
    
    @discardableResult
    func requestData(
        _ url: URL,
        completeHandler: @escaping (Data, URLResponse) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask?
    
    @discardableResult
    func requestData(
        _ urlRequest: URLRequest,
        completeHandler: @escaping (Data, URLResponse) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask?
}

extension NetworkAble {
    
    @discardableResult
    func requestData(
        _ url: URL,
        completeHandler: @escaping (Data, URLResponse) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            
            guard error == nil else {
                errorHandler(NetworkError.sessionError)
                return
            }
            
            guard let response = response,
                    let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200..<300).contains(statusCode) else {
                errorHandler(NetworkError.statusCodeError)
                return
            }
            
            guard let data = data else {
                errorHandler(NetworkError.dataError)
                return
            }
            completeHandler(data, response)
        }
        dataTask.resume()
        return dataTask
    }
    
    @discardableResult
    func requestData(
        _ urlRequest: URLRequest,
        completeHandler: @escaping (Data, URLResponse) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        
        let dataTask = session.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                errorHandler(NetworkError.sessionError)
                return
            }
            
            guard let response = response,
                  let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  (200..<300).contains(statusCode) else {
                errorHandler(NetworkError.statusCodeError)
                return
            }
            
            guard let data = data else {
                errorHandler(NetworkError.dataError)
                return
            }
            
            completeHandler(data, response)
        }
        dataTask.resume()
        return dataTask
    }
}
