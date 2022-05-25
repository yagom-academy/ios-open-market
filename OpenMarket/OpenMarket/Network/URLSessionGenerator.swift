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
    
    func request(endpoint: Endpoint, body: String, identifier: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        guard let url = endpoint.url else {
            return
        }
        let jsonData = body.data(using: .utf8)
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue(identifier, forHTTPHeaderField: "identifier")
        request.httpBody = jsonData
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func request(endpoint: Endpoint, body: Data, identifier: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        guard let url = endpoint.url else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue(identifier, forHTTPHeaderField: "identifier")
        request.setValue("multipart/form-data; boundary=\"\(API.boundary)\"", forHTTPHeaderField: "Content-Type")
        request.httpBody = body
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
