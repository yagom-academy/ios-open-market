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
        request.setValue(API.identifier, forHTTPHeaderField: "identifier")
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    func request(endpoint: Endpoint, body: Data, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void){
        guard let url = endpoint.url else {
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = endpoint.method
        request.setValue(API.identifier, forHTTPHeaderField: "identifier")
        if endpoint == .registerProduct {
            request.setValue("multipart/form-data; boundary=\"\(API.boundary)\"", forHTTPHeaderField: "Content-Type")
        } else {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        request.httpBody = body
        session.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
