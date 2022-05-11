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

