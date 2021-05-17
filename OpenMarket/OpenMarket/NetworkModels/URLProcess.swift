//
//  URLProcess.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class URLProcess {
    
    let baseURL:URL? = URL(string: "https://camp-open-market-2.herokuapp.com/")
    
    func setURLPath(methodType: String, index: String = "", isPage: Bool = true) -> URL? {
        
        switch methodType {
        case HttpMethodType.get.stringMethod :
            if isPage {
                return refactorURL(firstPath: "items", secondPath: index)
            }
            return refactorURL(firstPath: "item", secondPath: index)
        case HttpMethodType.post.stringMethod :
            return refactorURL(firstPath: "item", secondPath: index)
        case HttpMethodType.patch.stringMethod :
            return refactorURL(firstPath: "item", secondPath: index)
        case HttpMethodType.delete.stringMethod :
            return refactorURL(firstPath: "item", secondPath: index)
        default:
            return nil
        }
        
    }
    
    func refactorURL(firstPath: String, secondPath: String) -> URL? {
        guard let relativeURL = URL(string: "\(firstPath)/\(secondPath))", relativeTo: baseURL) else { return nil }
        print("\(baseURL)\(firstPath)/\(secondPath))")
        return relativeURL
    }
    
    func setURLRequest(requestMethodType: String, boundary: String = "") -> URLRequest? {
        
        guard let url = setURLPath(methodType: requestMethodType) else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethodType
        
        switch requestMethodType {
        case HttpMethodType.post.stringMethod, HttpMethodType.post.stringMethod:
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            return request
        case HttpMethodType.delete.stringMethod:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            return request
        default:
            return nil
        }
    
    }
    
    func checkResponseCode(response: URLResponse?) -> Bool {
        guard let successResponse = (response as? HTTPURLResponse)?.statusCode else { return false }
        
        if successResponse >= 200 && successResponse < 300 { return true }
        
        return false
    }
    
}
