//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by kio on 2021/06/10.
//
import Foundation
import UIKit
@testable import OpenMarket

class MockURLSession: MockURLSessionProtocol {
    var isRequestSuccess: Bool
    let sessionDataTask = MockURLSessionDataTask()
    let mockData = NSDataAsset(name: "Items")!.data
    
    init(isRequestSuccess: Bool = true){
        self.isRequestSuccess = isRequestSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let successResponse = HTTPURLResponse(url: Network.firstPage.url,
                                              statusCode: 200,
                                              httpVersion: "2",
                                              headerFields: nil)
        let failureResponse = HTTPURLResponse(url: Network.firstPage.url,
                                              statusCode: 402,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        switch isRequestSuccess {
        case true:
            sessionDataTask.resumeDidCall = { completionHandler(self.mockData, successResponse, nil) }
        case false:
            sessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        }
        
        return sessionDataTask
    }
}
