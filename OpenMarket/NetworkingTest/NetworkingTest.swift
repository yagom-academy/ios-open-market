//
//  NetworkingTest.swift
//  NetworkingTest
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import XCTest

@testable import OpenMarket
final class NetworkingTest: XCTestCase {
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_checkAPIHelath를_통해_서버가_정상적으로_응답을하는_true_값을_반환하는지() {
        let promise = expectation(description: "test")
        
        sut.checkAPIHealth { bool in
            XCTAssertEqual(true, bool)
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3)
    }
    
    func test_fetchItemList메서드를_사용해_itemList를_가져올때_pageNo값과_pageCount_값이_동일한지() {
        let promise = expectation(description: "test")
        let pageNo = 1
        let pageCount = 100
        
        sut.fetchItemList(pageNo: pageNo, pageCount: pageCount) { result in
            switch result {
            case .success(let itemList):
                XCTAssertEqual(itemList.itemsPerPage, pageCount)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 3)
    }
    
    func test_fetchItemList메서드를_사용해_itemList를_가져올때_pageNo에_유효하지_않은_값을_넣었을때_컨텐츠를_가져오지_못하는지() {
        let promise = expectation(description: "test")
        let pageNo = 2
        let pageCount = 1000
        
        sut.fetchItemList(pageNo: pageNo, pageCount: pageCount) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(NetworkError.parseError, error)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 3)
    }
    
    func test_fetchItem메서드를_사용해_Item을_가져올때_유효한_값을_가져오는지() {
        let promise = expectation(description: "test")
        let productId = 32
        
        sut.fetchItem(productId: productId) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, productId)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 3)
    }
    
    func test_fetchItem메서드를_사용해_Item을_가져올때_유효하지않은값으로_가져오려할때_에러가_발생하는지() {
        let promise = expectation(description: "test")
        let productId = 32123
        
        sut.fetchItem(productId: productId) { result in
            switch result {
            case .success(_):
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, NetworkError.responseError)
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 3)
    }
}
