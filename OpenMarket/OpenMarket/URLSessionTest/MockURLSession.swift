//
//  MockURLSession.swift
//  URLSessionTest
//
//  Created by song on 2022/05/12.
//

import UIKit
@testable import OpenMarket

struct MockData {
    func load() -> Data? {
        guard let asset = NSDataAsset(name: "products") else {
            return nil
        }
        return asset.data
    }
}

class MockURLSessionDataTask: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    override func resume() {
        closure()
    }
}

class MockURLSession: URLSessionProtocol {

    func dataTask(with urlRequest: URLRequest, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        let successResponse = HTTPURLResponse(url: urlRequest.url!, statusCode: 200, httpVersion: "", headerFields: nil)

        return URLSessionDataTaskMock { completionHandler( MockData().load(), successResponse, nil) }
    }
}
