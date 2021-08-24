//
//  MockURLSession.swift
//  OpenMarketUnitTests
//
//  Created by 이윤주 on 2021/08/17.
//

import Foundation

@testable import OpenMarket

class MockURLSession: URLSessionProtocol {
    private let mockURLSessionDataTask = MockURLSessionDataTask()
    var isSuccess: Bool
    
    init(isSuccess: Bool) {
        self.isSuccess = isSuccess
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let success = HTTPURLResponse(url: request.url!,
                                     statusCode: 200,
                                     httpVersion: nil,
                                     headerFields: nil)
        
        let failure = HTTPURLResponse(url: request.url!,
                                    statusCode: 400,
                                    httpVersion: nil,
                                    headerFields: nil)
        
        enum DummyURL: String {
            case item = "https://camp-open-market-2.herokuapp.com/item/1"
            case items = "https://camp-open-market-2.herokuapp.com/items/1"
            
            var fileName: String {
                switch self {
                case .item:
                    return "Item"
                case .items:
                    return "Items"
                }
            }
        }
        
        guard let fileName = DummyURL(rawValue: request.url!.absoluteString)?.fileName else {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, failure, nil) }
            return mockURLSessionDataTask
        }
        
        let path = Bundle(for: type(of: self)).path(forResource: fileName, ofType: "json")
        let jsonData = try? String(contentsOfFile: path!).data(using: .utf8)
        
        guard let data = jsonData else {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, failure, nil) }
            return mockURLSessionDataTask
        }
        if self.isSuccess {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(data, success, nil) }
        } else {
            mockURLSessionDataTask.resumeDidCall = { completionHandler(nil, failure, nil) }
        }
        
        return mockURLSessionDataTask
    }
}
