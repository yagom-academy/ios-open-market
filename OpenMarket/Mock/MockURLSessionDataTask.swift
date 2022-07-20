//
//  MockURLSessionDataTask.swift
//  OpenMarket
//
//  Created by 데릭, 케이, 수꿍. 
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
