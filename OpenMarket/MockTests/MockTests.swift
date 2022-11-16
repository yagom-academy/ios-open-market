//
//  MockTests.swift
//  MockTests
//
//  Created by 스톤, 로빈 on 2022/11/16.
//

import XCTest

@testable import OpenMarket
final class MockTests: XCTestCase {
    var sut: NetworkManager!
    let url: String = "https://openmarket.yagom-academy.kr/"
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_checkAPIHelath를_통해_정상적으로_응답을하는_true_값을_반환하는지() {
        let promise = expectation(description: "test")
        
        guard let url = URL(string: "\(url)healchecker") else { return }

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: nil, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        
        sut.session = stubUrlSession
        sut.checkAPIHealth { bool in
            bool ? XCTAssertEqual(true, bool) : XCTFail()
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3)
    }
    
    func test_fetchItemList메서드를_사용해_itemList를_가져올때_pageNo값과_itemsPerPage값이_동일한지() {
        let promise = expectation(description: "test")
        
        let pageNo: Int = 3
        let perPage = 20
        guard let url = URL(string: "\(url)api/products?page_no=\(pageNo)&items_per_page=\(perPage)") else { return }
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "itemList") else { return }

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: dataAsset.data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        
        sut.session = stubUrlSession
        
        sut.fetchItemList(pageNo: pageNo, pageCount: perPage) { result in
            switch result {
            case .success(let itemList):
                XCTAssertEqual(pageNo, itemList.pageNo)
                XCTAssertEqual(perPage, itemList.itemsPerPage)
            case .failure(_):
                XCTFail()
            }
            promise.fulfill()
        }
        
        wait(for: [promise], timeout: 3)
    }
    
    func test_fetchItem메서드를_사용해_Item을_가져올때_유효한_값을_가져오는지() {
        let promise = expectation(description: "test")
        
        let productId = 188
        guard let url = URL(string: "\(url)api/products/\(productId)") else { return }
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "item") else { return }

        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: dataAsset.data, response: response, error: nil)
        let stubUrlSession = StubURLSession(dummy: dummy)
        
        sut.session = stubUrlSession
        
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
}
