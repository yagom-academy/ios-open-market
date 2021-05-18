//
//  MockSession.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2021/05/18.
//

import Foundation
@testable import OpenMarket

struct MockURLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest,
                  completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: URL(string: "")!)
    }
}
