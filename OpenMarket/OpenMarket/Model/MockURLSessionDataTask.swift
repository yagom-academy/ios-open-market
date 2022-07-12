//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by 전민수 on 2022/07/12.
//

import Foundation

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let handler: () -> Void
    
    init(handler: @escaping () -> Void) {
        self.handler = handler
    }
    
    func resume() {
        handler()
    }
}
