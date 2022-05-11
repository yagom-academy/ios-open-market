//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//
//  Created by cathy, mmim.
//

import Foundation
@testable import OpenMarket

final class MockURLSessionDataTask: URLSessionDataTask {
  var resumeDidCall: () -> Void = {}
  
  override func resume() {
    resumeDidCall()
  }
}
