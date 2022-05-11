//
//  NetworkModelTest.swift
//  OpenMarketModelTests
//
//  Created by Red, Mino on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class NetworkProductListTest: XCTestCase {
    var sut: APIProvider<Products>!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = APIProvider<Products>()
    }

    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_APIProvider_getProductsList_request를호출할때_예상값을반환() {
        // given
        let promise = expectation(description: "")
        let endpoint = EndPointStorage.getProductsList(pageNumber: 1, perPages: 10)
        
        // when
        sut.request(with: endpoint) { result in
            switch result {
            case .success(let data):
                let result = data.pageNo
                let expected = 1
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

