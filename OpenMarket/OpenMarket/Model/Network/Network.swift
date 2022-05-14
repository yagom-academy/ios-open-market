//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

protocol NetworkAble {
    @discardableResult
    func requestData(
        url: String,
        completeHandler: @escaping (Data?, URLResponse?) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask?
}

final class Network: NetworkAble {
    
    private enum Constant {
        static let successRange = 200..<300
    }
    
    private let session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    @discardableResult
    func requestData(
        url: String,
        completeHandler: @escaping (Data?, URLResponse?) -> Void,
        errorHandler: @escaping (Error) -> Void
    ) -> URLSessionDataTask? {
        
        let urlComponents = URLComponents(string: url)
        guard let requestURL = urlComponents?.url else {
            errorHandler(NetworkError.urlError)
            return nil
        }
        
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            
            guard error == nil else {
                errorHandler(NetworkError.sessionError)
                return
            }
            
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                Constant.successRange.contains(statusCode) else {
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

