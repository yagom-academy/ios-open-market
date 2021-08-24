//
//  APIManagerTests.swift
//  OpenMarketTests
//
//  Created by 이예원 on 2021/08/19.
//

import XCTest
@testable import OpenMarket

class APIManagerTests: XCTestCase {

    var sut: APIManager!
    let session = MockURLSession(isRequestSuccess: true)
    
    override func setUpWithError() throws {
        sut = APIManager(session: session)
    }
    
    func test_mockURLSession을사용할경우_() throws {
        sut.fetchProductList(page: 1) { result in
            switch result {
            case .success(let data):
                XCTAssertEqual(data.items.first?.title, "MacBook Pr")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func tearDownWithError() throws {
        sut = nil
    }

}
