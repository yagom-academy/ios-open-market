//
//  APIManager.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/25.
//

import Foundation

struct APIManager {
    static func requestGET(url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
    
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    static func requestPOST(url: URL) {
        
    }
    
    static func requestPATCH(url: URL) {
        
    }
    
    static func requestDELETE(url: URL) {
        
    }
}


