//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by 박태현 on 2021/08/31.
//

import UIKit

class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    let sessionDataTask = MockURLSessionDataTask()
    let url = URL(string: APIURL.baseURL + "/item")!
    let mockData = "MockItem"
    
    init(isRequestSuccess: Bool) {
        self.isRequestSuccess = isRequestSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url, statusCode: 402, httpVersion: "2", headerFields: nil)
        
        if isRequestSuccess, let sampleDataAsset = NSDataAsset(name: mockData) {
            let sampleData = sampleDataAsset.data
            sessionDataTask.resumeDidCall = { completionHandler(sampleData, successResponse, nil) }
        } else {
            sessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        }
        
        return sessionDataTask
    }
}
