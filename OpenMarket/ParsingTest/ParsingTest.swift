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
    var sessionMock: Http!
    
    override func setUp() {
        super.setUp()
        sessionMock = SessionMock()
    }
    
    override func tearDown() {
        super.tearDown()
        sessionMock = nil
    }
    
    func test_정상적인url로_items에_1번page로_접근하면_아이템목록이있다() {
        let index = UInt(1)
        
        sessionMock.getItems(pageIndex: index) { result in
            switch result {
            case .success(let itemList):
                XCTAssertTrue(itemList.items.count > 0)
            case .failure(let error):
                XCTAssertEqual("check", error.message)
            }
        }
    }
    
    func test_정상적인url로_items에_100번page로_접근하면_아이템목록이없다() {
        let index = UInt(100)
        
        sessionMock.getItems(pageIndex: index) { result in
            switch result {
            case .success(let itemList):
                XCTAssertTrue(itemList.items.count == 0)
            case .failure(let error):
                XCTAssertEqual("check", error.message)
            }
        }
    }
    
}
