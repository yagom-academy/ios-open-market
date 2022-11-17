//
//  MockURLSession.swift
//  OpenMarket
//
//  Created by Kyo, LJ on 2022/11/16.
//

import Foundation

class MockURLSession: URLSessionProtocol {
    typealias Response = (data: Data?, urlResponse: URLResponse?, error: Error?)
    
    let response: Response
    init(response: Response) {
        self.response = response
    }
    
    func dataTask(with request: URLRequest,
                  completionHandler:
                  @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        
        return MockURLSessionDataTask {
            completionHandler(self.response.data,
                              self.response.urlResponse,
                              self.response.error)
        }
    }
    
    static func makeMockSenderSession(url: URL, data: Data?, statusCode: Int) -> MockURLSession {
        let mockURLSession: MockURLSession = {
            let urlResponse = HTTPURLResponse(url: url,
                                              statusCode: statusCode,
                                              httpVersion: nil,
                                              headerFields: nil)
            let mockResponse: MockURLSession.Response = (data: data,
                                                         urlResponse: urlResponse,
                                                         error: nil)
            let mockUrlSession = MockURLSession(response: mockResponse)
            return mockUrlSession
        }()
        
        return mockURLSession
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let resumeHandler: () -> Void
    
    init(resumeHandler: @escaping () -> Void) {
        self.resumeHandler = resumeHandler
    }
    
    func resume() {
        resumeHandler()
    }
}
