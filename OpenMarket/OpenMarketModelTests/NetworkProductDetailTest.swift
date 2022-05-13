//
//  NetworkModelTest.swift
//  OpenMarketModelTests
//
//  Created by Red, Mino on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class NetworkProductDetailTest: XCTestCase {
    var sut: APIProvider<ProductDetail>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APIProvider<ProductDetail>()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_APIProvider_getProductsDetail_request를호출할때_예상값을반환() {
        // given
        let promise = expectation(description: "")
        let endpoint = EndPointStorage.productsDetail(id: "522")
        
        // when
        sut.request(with: endpoint) { result in
            switch result {
            case .success(let data):
                let result = data.name
                let expected = "아이폰13"
                XCTAssertEqual(expected, result)
            case .failure(let error):
                print(error.localizedDescription)
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 10)
    }

}
