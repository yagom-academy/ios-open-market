//
//  MockURLSession.swift
//  OpenMarketTests
//  Created by Lingo, Quokka

import Foundation

protocol URLSessionProtocol {
  func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask
}

extension URLSession: URLSessionProtocol {}

final class MockURLSession: URLSessionProtocol {
  private let task = MockURLSessionDataTask()
  private let hasRequestFail: Bool
  
  init(hasRequestFail: Bool = false) {
    self.hasRequestFail = hasRequestFail
  }
  
  func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask {
    let successResponse = HTTPURLResponse(
      url: url,
      statusCode: 200,
      httpVersion: "1.1",
      headerFields: nil)
    let failureResponse = HTTPURLResponse(
      url: url,
      statusCode: 404,
      httpVersion: "1.1",
      headerFields: nil)
    
    if hasRequestFail == true {
      self.task.setHandler { completionHandler(nil, failureResponse, nil) }
    } else {
      self.task.setHandler { completionHandler(MockData().data, successResponse, nil) }
    }
    return task
  }
}

