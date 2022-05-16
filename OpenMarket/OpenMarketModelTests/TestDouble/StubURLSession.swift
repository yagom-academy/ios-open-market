//
//  StubURLSession.swift
//  OpenMarketModelTests
//
//  Created by Red, Mino on 2022/05/10.
//

import UIKit
@testable import OpenMarket

final class StubURLSession: URLSessionProtocol {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let successResponse = HTTPURLResponse(
            url: URL(string: "http://test")!,
            statusCode: 200,
            httpVersion: "2",
            headerFields: nil
        )
        let completion: () -> Void = {}
        let sessionDataTask = StubURLSessionDataTask(resumeHandler: completion)
        
        do {
            let urlData = try Data(contentsOf: url)
            
            sessionDataTask.resumeHandler = {
                completionHandler(urlData, successResponse, nil)
            }
            
            return sessionDataTask
        } catch { }
        
        return sessionDataTask
    }
    
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let file = NSDataAsset(name: "products")
        
        let endPoint = EndPoint(
            baseURL: "TEST",
            sampleData: file?.data
        )
        
        let successResponse = HTTPURLResponse(
            url: URL(string: endPoint.baseURL)!,
            statusCode: 200,
            httpVersion: "2",
            headerFields: nil
        )
        
        let completion: () -> Void = {}
        
        let sessionDataTask = StubURLSessionDataTask(resumeHandler: completion)
        
        sessionDataTask.resumeHandler = {
            completionHandler(endPoint.sampleData, successResponse, nil)
        }
                
        return sessionDataTask
    }
}

final class StubURLSessionDataTask: URLSessionDataTaskProtocol {
    var resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}
