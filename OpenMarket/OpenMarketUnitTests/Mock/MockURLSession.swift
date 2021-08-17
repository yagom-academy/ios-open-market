//
//  MockURLSession.swift
//  OpenMarketUnitTests
//
//  Created by 이윤주 on 2021/08/17.
//

import Foundation

@testable import OpenMarket

class MockURLSession: URLSessionProtocol {
    let mockURLSessionDataTask = MockURLSessionDataTask()
    var isSuccess: Bool = true
    
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
                    return "item"
                case .items:
                    return "items"
                }
            }
        }
        
        guard let fileName = DummyURL(rawValue: request.url!.absoluteString)?.fileName else {
            fatalError("URL 이상함")
        }
        
        let path = Bundle.main.path(forResource: fileName, ofType: "json")
        let jsonData = try? String(contentsOfFile: path!).data(using: .utf8)
        
        guard let data = jsonData else {
            fatalError()
        }
        
        mockURLSessionDataTask.resumeDidCall = { completionHandler(data, self.isSuccess ? success : failure, nil)}
        
        return mockURLSessionDataTask
    }
}
