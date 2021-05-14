//
//  URLProcess.swift
//  OpenMarket
//
//  Created by sookim on 2021/05/14.
//

import Foundation

class URLProcess {
    
    let baseURL:URL? = URL(string: "https://camp-open-market-2.herokuapp.com/")
    
    
    func setURLPath(methodType: String) -> URL? {
        
        switch methodType {
        case HttpMethodType.get.stringMethod :
            guard let relativeURL = URL(string: "items/1", relativeTo: baseURL) else { return nil }
            return relativeURL
        case HttpMethodType.post.stringMethod :
            guard let relativeURL = URL(string: "item", relativeTo: baseURL) else { return nil }
            return relativeURL
        case HttpMethodType.patch.stringMethod :
            guard let relativeURL = URL(string: "item/112", relativeTo: baseURL) else { return nil }
            return relativeURL
        case HttpMethodType.delete.stringMethod :
            guard let relativeURL = URL(string: "item/112", relativeTo: baseURL) else { return nil }
            return relativeURL
        default:
            return nil
        }
    }
    
    func setURLRequest(requestMethodType: String, boundary: String) -> URLRequest? {
        // URLRequest 객체를 정의
        guard let url = setURLPath(methodType: requestMethodType) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestMethodType
        // HTTP 메시지 헤더
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    func checkResponseCode(response: URLResponse?) -> Bool {
        guard let successResponse = (response as? HTTPURLResponse)?.statusCode else { return false }
        
        if successResponse >= 200 && successResponse < 300 { return true }
        
        return false
    }
    
}
