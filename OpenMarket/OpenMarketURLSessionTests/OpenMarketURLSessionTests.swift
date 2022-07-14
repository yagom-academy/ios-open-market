//
//  OpenMarketURLSessionTests.swift
//  OpenMarketURLSessionTests
//
//  Created by dhoney96 on 2022/07/12.
//

import XCTest
@testable import OpenMarket

class OpenMarketURLSessionTests: XCTestCase {
    let mockSession = MockURLSession()
    var sut: OpenMarketURLSession!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = .init(session: mockSession)
    }
    
    func test_getMethod_성공() {
        // given
        let response: ItemList? = JSONDecoder.decodeJson(jsonData: MockData().data)
        
        // when,then
        sut.getMethod { result in
            switch result {
            case .success(let data):
                guard let itemList: ItemList? = JSONDecoder.decodeJson(jsonData: data!) else {
                    XCTFail("Decode Error")
                    return
                }
                XCTAssertEqual(itemList?.pageNumber, response?.pageNumber)
                XCTAssertEqual(itemList?.itemsPerPage, response?.itemsPerPage)
            case .failure(_):
                XCTFail("getMethod failure")
            }
        }
    }
    
    func test_getMethod_실패() {
        // given
        sut = OpenMarketURLSession(session: MockURLSession(isRequestSuccess: false))
        
        // when,then
        sut.getMethod { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.statusError)
            }
        }
    }
}
