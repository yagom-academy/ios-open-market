//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    let response: Response
    
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return MockURLSessionDataTask(resumeHandler: {
            completionHandler(self.response.data, self.response.urlResponse, self.response.error)
        })
    }
}
