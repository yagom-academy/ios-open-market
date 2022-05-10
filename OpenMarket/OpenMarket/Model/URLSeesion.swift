//
//  URLSeesion.swift
//  OpenMarket
//
//  Created by 두기, minseong on 2022/05/10.
//

import Foundation

final class NetworkHandler {
    static func getData(urlString: String, completionHandler: @escaping (_ data: Data) -> Void) {
        let session = URLSession(configuration: .default)
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        let request = URLRequest(url: url)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode < 300 else {
                return
            }
            
            completionHandler(data)
        }
        
        dataTask.resume()
    }
}
