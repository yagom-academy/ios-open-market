//
//  Network.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/10.
//

import Foundation

protocol NetworkAble {
    func requestData(url: String,
                     query: [(String, String)]?,
                     completeHandler: @escaping (Data?, URLResponse?, Error?) -> Void )
}

final class Network: NetworkAble {
    
    func requestData(url: String,
                     query: [(String, String)]?,
                     completeHandler: @escaping (Data?, URLResponse?, Error?) -> Void ) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        var urlComponents = URLComponents(string: url)
        if let query = query {
            for item in query {
                let urlQueryItem = URLQueryItem(name: item.0, value: item.1)
                urlComponents?.queryItems?.append(urlQueryItem)
            }
        }
        
        guard let requestURL = urlComponents?.url else { return }
        let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
            guard error == nil else { return }
            completeHandler(data, response, error)
        }
        dataTask.resume()
    }
}
