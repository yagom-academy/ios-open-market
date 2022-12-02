//
//  NetworkManager.swift
//  OpenMarket
//
//  Created by Ayaan, junho on 2022/11/30.
//

import UIKit.UIImage

struct NetworkManager {
    let openMarketAPI: OpenMarketAPI
    
    func network(completionHandler: @escaping (Data?, Error?) -> Void) {
        guard let hostURL: URL = URL(string: openMarketAPI.baseURL),
              let url: URL = URL(string: openMarketAPI.path, relativeTo: hostURL) else {
            completionHandler(nil, OpenMarketError.invalidURL())
            return
        }
        var request: URLRequest = URLRequest(url: url)
        openMarketAPI.headers.forEach {
            request.addValue($0.value, forHTTPHeaderField: $0.key)
        }
        request.httpMethod = openMarketAPI.method.text
        request.httpBody = openMarketAPI.body
        
        URLSession.shared.dataTask(with: request) {data, response, error in
            if let error: Error = error {
                completionHandler(nil, error)
            } else if let httpResponse: HTTPURLResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) == false {
                completionHandler(nil, OpenMarketError.badStatus())
            } else if let data: Data = data {
                completionHandler(data, nil)
            } else {
                completionHandler(nil, OpenMarketError.unknownError())
            }
        }.resume()
    }
}
