//
//  URLSessionProtocol.swift
//  OpenMarket
//  Created by Lingo, Quokka on 2022/05/11.
//

import Foundation

protocol URLSessionable {
  func dataTask(
    with url: URL,
    completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
  ) -> URLSessionDataTask
}
