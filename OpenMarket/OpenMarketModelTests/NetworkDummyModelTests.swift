//
//  OpenMarketModelTests.swift
//  OpenMarketModelTests
//
//  Created by Red, Mino on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class NetworkDummyModelTests: XCTestCase {
    var sut: APIProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APIProvider()
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_retrieveProductList를호출할때_예상값을반환() {
        // given
        guard let file = NSDataAsset(name: "products") else {
            return
        }
        
        let promise = expectation(description: "")
        let url = URL(string: "https://market-training.yagom-academy.kr/")!
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: file.data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        sut = APIProvider(urlSession: stubUrlSession)
        
        // when

        
        wait(for: [promise], timeout: 10)
    }
}
