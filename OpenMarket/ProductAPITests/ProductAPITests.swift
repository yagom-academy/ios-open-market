//
//  ProductAPITests.swift
//  ProductAPITests
//
//  Created by Gordon Choi on 2022/07/11.
//

import XCTest
@testable import OpenMarket

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: DataTaskCompletionHandler? = nil

    func completion() {
        completionHandler?(data, response, error)
    }
}

class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?

    init(dummy: DummyData) {
        self.dummyData = dummy
    }

    func dataTask(with request: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
        return StubURLSessionDataTask(dummy: dummyData, completionHandler: completionHandler)
    }
}

class StubURLSessionDataTask: URLSessionDataTask {
    var dummyData: DummyData?

    init(dummy: DummyData?, completionHandler: DataTaskCompletionHandler?) {
        self.dummyData = dummy
        self.dummyData?.completionHandler = completionHandler
    }

    override func resume() {
        dummyData?.completion()
    }
}

class ProductAPITests: XCTestCase {
    var sut: ProductAPI!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ProductAPI()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_데이터를_요청했을때_불러온_데이터를_반환() {
        // given
        let promise = expectation(description: "URLSession Data")
        let expectation = "USD"

        // when
        sut.call("https://market-training.yagom-academy.kr/api/products?page-no=1&items-per-page=10",
                 for: Products.self) { result in
            switch result {
            case .success(let products):
                // then
                XCTAssertNotEqual(expectation, products.pages[0].currency)
                promise.fulfill()
            case .failure(_):
                XCTFail("Failed to load data")
            }
        }
        
        wait(for: [promise], timeout: 1)
    }
    
    func test_데이터를_요청했을때_불러온_DummyData를_반환() {
        // given
        let promise = expectation(description: "")
        let url = URL(string: "https://market-training.yagom-academy.kr/api/products?page-no=1&items-per-page=10")!

        do {
            let data = NSDataAsset.init(name: "products")?.data
            let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
            let dummy = DummyData(data: data, response: response, error: nil)
            let stubUrlSession = StubURLSession(dummy: dummy)
            sut = ProductAPI(session: stubUrlSession)
            let expectation = "KRW"

            // when
            sut.call("https://market-training.yagom-academy.kr/api/products?page-no=1&items-per-page=10",
                     for: Products.self) { result in
                switch result {
                case .success(let products):
                    // then
                    XCTAssertEqual(expectation, products.pages[0].currency)
                    promise.fulfill()
                case .failure(_):
                    XCTFail("Failed to load data")
                }
            }
            wait(for: [promise], timeout: 1)
        } catch {
            XCTFail("Failed to load data")
        }
    }
}
