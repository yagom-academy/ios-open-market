//
//  APIManager.swift
//  OpenMarket
//
//  Created by 김동빈 on 2021/01/25.
//

import Foundation

struct APIManager {
    typealias URLSessionHandling = (Data?, URLResponse?, Error?) -> Void
    
    static func requestGET(url: URL, completionHandler: @escaping URLSessionHandling) {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
    
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
    
    static func requestPOST(url: URL, uploadData: Data, completionHandler: @escaping URLSessionHandling) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = uploadData
    
        URLSession.shared.uploadTask(with: request, from: uploadData, completionHandler: completionHandler).resume()
    }
    
    static func requestPATCH(url: URL, patchData: Data, completionHandler: @escaping URLSessionHandling) {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = patchData
    
        URLSession.shared.uploadTask(with: request, from: patchData, completionHandler: completionHandler).resume()
    }
    
    static func requestDELETE(url: URL, deleteData: Data, completionHandler: @escaping URLSessionHandling) {
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = deleteData
        
        URLSession.shared.dataTask(with: request, completionHandler: completionHandler).resume()
    }
}



