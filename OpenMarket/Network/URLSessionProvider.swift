//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by 김태훈 on 2022/05/10.
//

import Foundation

class URLSessionProvider {
    let session: URLSession
    let apiHost: String = "https://market-training.yagom-academy.kr/"
    
    init (session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func sendGet(path: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        if let url: URL = URL(string: apiHost + path) {
            var request: URLRequest = URLRequest(url: url)
            request.httpMethod = "GET"
            session.dataTask(with: request, completionHandler: completionHandler).resume()
        }
    }
}
