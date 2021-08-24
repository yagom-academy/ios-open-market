//
//  ParsingTest.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/10.
//

import XCTest
@testable import OpenMarket

class ParsingTest: XCTestCase {
    
    let baseURL = HttpConfig.baseURL
    
    var cut: API!
    
    override func setUp() {
        super.setUp()
        cut = NetworkManagerMock()
    }
    
    override func tearDown() {
        super.tearDown()
        cut = nil
    }
    
    func test_sessionMock에_items에_1번page로_접근하면_아이템목록이있다() {
        let index = UInt(1)
        
        cut.getItems(pageIndex: index) { result in
            switch result {
            case .success(let itemList):
                XCTAssertTrue(itemList.items.count > 0)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_sessionMock에_items에_1번이아닌page로_접근하면_아이템목록이있다() {
        let randomNumber = Int.random(in: 2...Int.max)
        let index = UInt(randomNumber)
        
        cut.getItems(pageIndex: index) { result in
            switch result {
            case .success(let itemList):
                XCTAssertTrue(itemList.items.count == 0)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_sessionMock에_1번id를갖는item은_존재한다() {
        let id = UInt(1)
        
        cut.getItem(id: id) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, 1)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_sessionMock에_1234번id를갖는item은_존재하지않는다() {
        let id = UInt(1234)
        
        cut.getItem(id: id) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.errorDescription, NetworkManagerMock.ErrorCases.noItem)
            }
        }
    }
}
