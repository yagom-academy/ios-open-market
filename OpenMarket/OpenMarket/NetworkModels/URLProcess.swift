//
//  URLProcess.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class URLProcess: URLProcessUsable {
    
    func setBaseURL(urlString: String) -> URL? {
        guard let resultURL = URL(string: urlString) else { return nil }
        return resultURL
    }
    
    func setUserActionURL(baseURL: URL, userAction: UserAction, index: String = "") -> URL? {
        switch userAction {
        case .viewArticleList:
            return URL(string: "items/" + index , relativeTo: baseURL)
        case .addArticle:
            return URL(string: "item" , relativeTo: baseURL)
        default :
            return URL(string: "item/" + index , relativeTo: baseURL)
        }
    }
    
    func setURLRequest(url: URL, userAction: UserAction, boundary: String? = nil) -> URLRequest? {
        var request = URLRequest(url: url)
        request.httpMethod = userAction.setHttpMethod()
        
        switch userAction.setHttpMethod() {
        case HttpMethodType.post.stringMethod, HttpMethodType.patch.stringMethod:
            guard let boundary = boundary else { return nil }
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
