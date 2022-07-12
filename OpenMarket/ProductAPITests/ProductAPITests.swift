//
//  ProductAPITests.swift
//  ProductAPITests
//
//  Created by Gordon Choi on 2022/07/11.
//

import XCTest
@testable import OpenMarket

struct MockData {
    let data: Data? = NSDataAsset.init(name: "products")?.data
}

class MockURLSessionDataTask: URLSessionDataTask {
    override init() {}
    var resumeDidCall: () -> Void = {}

    override func resume() {
        resumeDidCall
    }
}

class MockURLSession: URLSessionProtocol {
    var isRequestSuccess: Bool
    var sessionDataTask: MockURLSessionDataTask?

    init(isRequestSuccess: Bool = true) {
        self.isRequestSuccess = isRequestSuccess
    }

    func dataTask(with request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {

        let successResponse = HTTPURLResponse(url: request.url!,
                                             statusCode: 200,
                                             httpVersion: "2",
                                             headerFields: nil)
        let failureResponse = HTTPURLResponse(url: request.url!,
                                              statusCode: 402,
                                              httpVersion: "2",
                                              headerFields: nil)

        let sessionDataTask = MockURLSessionDataTask()

        if isRequestSuccess {
            sessionDataTask.resumeDidCall = {
                completionHandler(MockData().data, successResponse, nil)
            }
        } else {
            sessionDataTask.resumeDidCall = {
                completionHandler(nil, failureResponse, nil)
            }
        }

        self.sessionDataTask = sessionDataTask
        return sessionDataTask
    }
}

class ProductAPITests: XCTestCase {
    let mockSession = MockURLSession()
    var sut: ProductAPI!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = .init(session: mockSession)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_데이터를_불러왔을때_불러온_데이터를_반환() {
        guard let data = MockData().data,
              let expectation = try? JSONDecoder().decode(Products.self, from: data) else {
            XCTFail("No data for expectation")
            return
        }

        sut.call("https://market-training.yagom-academy.kr/api/products?page-no=1&items-per-page=10",
                 for: Products.self) { result in
            switch result {
            case .success(let products):
                XCTAssertEqual(expectation, products)
            case .failure(_):
                XCTFail("Failed to load data")
            }
        }
    }
}
