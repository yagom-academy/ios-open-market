//
//  URL.swift
//  OpenMarket
//
//  Created by 김민성 on 2021/06/05.
//

import Foundation

struct CommonURLProcess {
    private let baseURL = "https://camp-open-market-2.herokuapp.com/"
    
    typealias URLInformation = (url: URL, urlMethod: String)
    
    func completedURL<T: Decodable>(model : T.Type, urlMethod: String, index: String?) -> URLInformation {
        
        guard let index = index else {
            return (URL(string: self.baseURL + "item")!, urlMethod)
        }
        
        if urlMethod == HttpMethod.get.rawValue && model == GetProductList.self {
            return (URL(string: self.baseURL + "items/\(index)")!, urlMethod)
        } else {
            return (URL(string: self.baseURL + "item/\(index)")!, urlMethod)
        }
    }
    
    func requiredURLRequest(urlInformation : URLInformation, boundary: String?) -> URLRequest? {
        var request = URLRequest(url: urlInformation.url)
        request.httpMethod = urlInformation.urlMethod
        
        if urlInformation.urlMethod == HttpMethod.delete.rawValue {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            return request
        } else {
            guard let boundary = boundary else { return nil }
    
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            
            return request
        }
    }
    
    
}
