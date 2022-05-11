//
//  MockURLSession.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import Foundation
@testable import OpenMarket

final class MockURLSession: URLSessionProtocol {
  private var sessionDataTask: MockURLSessionDataTask?
 
  func dataTask(with request: URLRequest,
                completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    
    let sucessResponse = HTTPURLResponse(url: request.url!,
                                         statusCode: 200,
                                         httpVersion: "2",
                                         headerFields: nil)
    
    let sessionDataTask = MockURLSessionDataTask()
    
    sessionDataTask.resumeDidCall = {
      completionHandler(MockData().loadData(), sucessResponse, nil)
    }
    
    self.sessionDataTask = sessionDataTask
    return sessionDataTask
  }
}
