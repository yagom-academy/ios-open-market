//
//  StubURLSession.swift
//  OpenMarketModelTests
//
//  Created by Red, Mino on 2022/05/10.
//

import UIKit
@testable import OpenMarket

final class StubURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
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
        
        let sessionDataTask = StubURLSessionDataTask()
        
        sessionDataTask.completion = {
            completionHandler(endPoint.sampleData, successResponse, nil)
        }
        
        return sessionDataTask
    }
}

final class StubURLSessionDataTask: URLSessionDataTask {
    var completion: (() -> ())?
    
    override func resume() {
        completion?()
    }
}
