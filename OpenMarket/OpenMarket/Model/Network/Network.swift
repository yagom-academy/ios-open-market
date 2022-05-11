//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

protocol NetworkAble {
    func requestData(url: String,
                     completeHandler: @escaping (Data?, URLResponse?, Error?) -> Void )
}

final class Network: NetworkAble {
    
    func requestData(url: String,
                     completeHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let urlComponents = URLComponents(string: url)
        
        guard let requestURL = urlComponents?.url else { return }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            guard error == nil else { return }
            completeHandler(data, response, error)
        }
        dataTask.resume()
    }
}
