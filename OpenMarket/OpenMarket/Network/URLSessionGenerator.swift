//
//  URLSessionGenerator.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation

final class URLSessionGenerator {
    private let session: CustomURLSession
    
    init (session: CustomURLSession = URLSession.shared) {
        self.session = session
    }
    
    func request(endpoint: Endpoint, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        guard let url = endpoint.url else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = endpoint.method
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
