//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

protocol NetworkAble {
    func requestData(url: String,
                     completeHandler: @escaping DataTaskCompletionHandler,
                     errorHandler: @escaping DataTaskErrorHandler)
}

final class Network: NetworkAble {
    
    private enum Constant {
        static let successRange = 200..<300
    }
    
    var session: URLSessionProtocol
    
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func requestData(url: String,
                     completeHandler: @escaping DataTaskCompletionHandler,
                     errorHandler: @escaping DataTaskErrorHandler) {
        
        let urlComponents = URLComponents(string: url)
        guard let requestURL = urlComponents?.url else {
            errorHandler(NetworkError.urlError)
            return
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
            
            completeHandler(data, response, error)
        }
        dataTask.resume()
    }
}

