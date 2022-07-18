//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by unchain, hyeon2 on 2022/07/12.
//

import XCTest

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager?
    var mockSession: MockURLSession?
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        mockSession = MockURLSession(isRequestSucess: true)
        sut = NetworkManager(session: mockSession!)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
        mockSession = nil
    }

    func test_상품리스트를_요청하면_매핑에_성공한다() {
        // given
        guard let assetData = NSDataAsset.init(name: "products", bundle: Bundle(for: NetworkManagerTests.self)) else {
            XCTFail("asset fail")
            return
        }
        let promise = expectation(description: "매핑 테스트")

        // when
        let result = try? JSONDecoder().decode(MarketInformation.self, from: assetData.data)
        sut?.getProductInquiry(request: nil, completion: { expectation in
            switch expectation {
            case .failure(_):
                XCTFail("failure")
            case .success(let data):
                guard let expectation = try? JSONDecoder().decode(MarketInformation.self, from: data) else {
                    XCTFail("decode error")
                    return
                }
                XCTAssertEqual(result?.pageNo, expectation.pageNo)
                promise.fulfill()
            }
        })
        
        wait(for: [promise], timeout: 5)
    }
}
