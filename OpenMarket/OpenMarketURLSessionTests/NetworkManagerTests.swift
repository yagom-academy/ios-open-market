//
//  NetworkManagerTests.swift
//  NetworkManagerTests
//
//  Created by Kiwi, Hugh on 2022/07/12.
//

import XCTest
@testable import OpenMarket

class NetworkManagerTests: XCTestCase {
    let mockSession = MockURLSession()
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = .init(session: mockSession)
    }
    
    func test_getMethod_성공() {
        // given
        let response: ItemList? = JSONDecoder.decodeJson(jsonName: "Products")
        let promise = expectation(description: "async Test")
        
        // when,then
        sut.getItemList(pageNumber: 1, itemsPerPage: 10) { result in
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
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_getMethod_실패() {
        // given
        sut = NetworkManager(session: MockURLSession(isRequestSuccess: false))
        
        // when,then
        sut.getItemList(pageNumber: 1, itemsPerPage: 10) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                XCTAssertEqual(error, ResponseError.statusError)
            }
        }
    }
}
