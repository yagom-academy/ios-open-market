//
//  MockURLSession.swift
//  URLSessionTest
//
//  Created by marlang, Taeangel on 2022/05/12.
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

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    func resume() {
        closure()
    }
}

class MockURLSession: URLSessionProtocol {

    func dataTask(
        with urlRequest: URLRequest,
        completionHandler: @escaping DataTaskCompletionHandler
    ) -> URLSessionDataTaskProtocol {
        let successResponse = HTTPURLResponse(
            url: urlRequest.url!,
            statusCode: 200, httpVersion: "",
            headerFields: nil
        )

        return MockURLSessionDataTask { completionHandler(
            MockData().load(),
            successResponse, nil
        ) }
    }
}
