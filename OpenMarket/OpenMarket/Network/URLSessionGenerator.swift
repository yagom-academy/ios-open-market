//
//  URLSessionProvider.swift
//  OpenMarket
//
//  Created by Grumpy, OneTool on 2022/05/10.
//

import Foundation

final class URLSessionGenerator {
    private let session: CustomURLSession
    private let apiHost: String = "https://market-training.yagom-academy.kr/"
    
    init (session: CustomURLSession = URLSession.shared) {
        self.session = session
    }
    
    func request(path: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        guard let url: URL = URL(string: apiHost + path) else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
