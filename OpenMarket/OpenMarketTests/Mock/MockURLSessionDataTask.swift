//
//  MockURLSessionDataTask.swift
//  OpenMarketTests
//  Created by Lingo, Quokka
//

import Foundation

final class MockURLSessionDataTask: URLSessionDataTask {
  private var handler: (() -> Void)?
  
  override func resume() {
    self.handler?()
  }
  
  func setHandler(_ handler: (() -> Void)?) {
    self.handler = handler
  }
}
