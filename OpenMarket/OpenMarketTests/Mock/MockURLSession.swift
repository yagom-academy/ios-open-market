//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import Foundation
import UIKit

final class MockURLSession: URLSessionProtocol {
    
    var isRequestSuccess: Bool
    init(isRequestSucess: Bool = true) {
        self.isRequestSuccess = isRequestSucess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        
        let sucessResponse = HTTPURLResponse(url: request.url!,
                                             statusCode: 200,
                                             httpVersion: "2",
                                             headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 404,
                                              httpVersion: "2",
                                              headerFields: nil)
        
        let sessionDataTask = MockURLSessionDataTask()
        let assetData = NSDataAsset(name: "products")?.data ?? Data()
        
        if isRequestSuccess {
            sessionDataTask.resumeHandler = {
                completionHandler(assetData, sucessResponse, nil)
            }
        } else {
            sessionDataTask.resumeHandler = {
                completionHandler(nil, failureResponse, nil)
            }
        }
        
        return sessionDataTask
    }
}
