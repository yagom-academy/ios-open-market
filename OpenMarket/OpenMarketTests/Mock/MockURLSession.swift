//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by tae hoon park on 2021/08/31.
//

import Foundation
@testable import OpenMarket

class MockURLSession: URLSessionProtocol {
    let parsingManager = ParsingManager()
    var url = URL(string: APIURL.getItem.description)!
    
    let sessionDataTask = MockURLSessionDataTask()
    var isRequestSucess: Bool
    
    init(isRequestSucess: Bool) {
        self.isRequestSucess = isRequestSucess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "2", headerFields: nil)
        let failureResponse = HTTPURLResponse(url: url, statusCode: 402, httpVersion: "2", headerFields: nil)
        
        if isRequestSucess {
            let sampleData = try? parsingManager.LoadedDataAsset(assetName: "Item").data
            sessionDataTask.resumeDidCall = { completionHandler(sampleData, successResponse, nil) }
        } else {
            sessionDataTask.resumeDidCall = { completionHandler(nil, failureResponse, nil) }
        }
        return sessionDataTask
    }
}
