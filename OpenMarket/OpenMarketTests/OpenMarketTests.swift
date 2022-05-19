//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Eddy, marisol on 2022/05/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sutProduct: NetworkManager<ProductsList>!
    var sutHealthChecker: NetworkManager<String>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sutProduct = NetworkManager<ProductsList>(session: URLSession.shared)
        sutHealthChecker = NetworkManager<String>(session: URLSession.shared)
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sutProduct = nil
        sutHealthChecker = nil
    }
    
    func test_Product_dummy데이터의_totalCount가_10과_일치한다() {
        // given
        let promise = expectation(description: "success")
        var totalCount: Int = 0
        let expectedResult: Int = 10

        guard let product = NSDataAsset(name: "products") else {
            XCTFail("Data 포맷팅 실패")
            return
        }
        
        let response = Response(data: product.data, statusCode: 200, error: nil)
        let dummyData = DummyData(response: response)
        let stubUrlSession = StubURLSession(dummy: dummyData)
        sutProduct.session = stubUrlSession

        // when
        sutProduct.execute(with: FakeAPI()) { result in
            switch result {
            case .success(let product):
                totalCount = product.totalCount
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 10)

        // then
        XCTAssertEqual(totalCount, expectedResult)
    }

    func test_statusCode를_400설정하면_발생하는에러가_statusCodeError와_일치한다() {
        // given
        let promise = expectation(description: "failure")

        guard let product = NSDataAsset(name: "products") else {
            XCTFail("Data 포맷팅 실패")
            return
        }

        let response = Response(data: product.data, statusCode: 400, error: nil)
        let dummyData = DummyData(response: response)
        let stubUrlSession = StubURLSession(dummy: dummyData)
        sutProduct.session = stubUrlSession

        var errorResult: NetworkError? = nil

        // when
        sutProduct.execute(with: FakeAPI()) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                errorResult = error
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 10)

        // then
        XCTAssertEqual(errorResult, NetworkError.statusCode)
    }

    func test_ProductDetail_dummy데이터의_vendorID와_3이_일치한다() {
        // given
        let promise = expectation(description: "success")
        var venderId: Int = 0
        let expectedResult: Int = 3

        guard let product = NSDataAsset(name: "products") else {
            XCTFail("Data 포맷팅 실패")
            return
        }

        let response = Response(data: product.data, statusCode: 200, error: nil)
        let dummyData = DummyData(response: response)
        let stubUrlSession = StubURLSession(dummy: dummyData)
        sutProduct.session = stubUrlSession

        // when
        sutProduct.execute(with: FakeAPI()) { result in
            switch result {
            case .success(let product):
                venderId = product.pages[0].vendorId
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            promise.fulfill()
        }

        wait(for: [promise], timeout: 10)

        // then
        XCTAssertEqual(venderId, expectedResult)
    }
    
    func test_healthCheckerPath_API_network_통신해서_가져온데이터가_OK와_일치한다() {
        // given
        let promise = expectation(description: "success")
        var okResult = ""
        let expectedResult = "OK"
        
        // when
        sutHealthChecker.execute(with: HealthChecker()) { result in
            switch result {
            case .success(let result):
                okResult = result
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
        
        //then
        XCTAssertEqual(okResult, expectedResult)
    }
}
