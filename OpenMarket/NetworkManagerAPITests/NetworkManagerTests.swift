//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Gordon Choi on 2022/07/11.
//

import XCTest
@testable import OpenMarket

struct DummyData {
    let data: Data?
    let response: URLResponse?
    let error: Error?
    var completionHandler: DataTaskCompletionHandler?

    func completion() {
        completionHandler?(data, response, error)
    }
}

class StubURLSession: URLSessionProtocol {
    var dummyData: DummyData?

    init(dummy: DummyData) {
        self.dummyData = dummy
    }

    func dataTask(with url: URL, completionHandler: @escaping DataTaskCompletionHandler) -> URLSessionDataTask {
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

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!

    override func setUpWithError() throws {
        try super.setUpWithError()

        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()

        sut = nil
    }

    func test_데이터를_요청했을때_성공을_가정하고_불러온_DummyData를_반환() {
        // given
        let promise = expectation(description: "Calling URLSession dummy data")
        let url = URL(string: "https://market-training.yagom-academy.kr/api/products?page-no=1&items-per-page=10")!

        let dummyData = NSDataAsset.init(name: "products")?.data
        let dummyResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: dummyData, response: dummyResponse, error: nil)

        let stubUrlSession = StubURLSession(dummy: dummy)
        sut = NetworkManager(session: stubUrlSession)

        let presetValue = "KRW"

        // when
        sut.requestAndDecode("https://market-training.yagom-academy.kr/api/products?page-no=1&items-per-page=10",
                 for: Products.self) { result in
            switch result {
            case .success(let products):
                // then
                XCTAssertEqual(presetValue, products.pages[0].currency)
                promise.fulfill()
            case .failure(_):
                XCTFail("Failed to load data")
                promise.fulfill()
            }
        }
        wait(for: [promise], timeout: 1)
    }
}
