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
    
    func test_비정상인url로_items에_접근하면_invaildPath에러가발생한다() {
        let givenURL = baseURL + "blah blah"
        let expectedResult = HttpConfig.invailedPath
        
        let result = sessionMock.httpGetItems(url: givenURL)
        
        switch result {
        case .success(let itemList):
            XCTAssertEqual("check", itemList.items.description)
        case .failure(let error):
            XCTAssertEqual(expectedResult, error.message)
        }
    }
    
    func test_정상적인url로_items에_비정상인page로_접근하면_invaildPath에러가발생한다() {
        let givenURL = baseURL + "/itesm/-1"
        let expectedResult = HttpConfig.invailedPath
        
        let result = sessionMock.httpGetItems(url: givenURL)
        
        switch result {
        case .success(let itemList):
            XCTAssertEqual("check", itemList.items.description)
        case .failure(let error):
            XCTAssertEqual(expectedResult, error.message)
        }
    }
    
    func test_정상적인url로_items에_1번page로_접근하면_아이템목록이있다() {
        let givenURL = baseURL + "/items/1"
        
        let result = sessionMock.httpGetItems(url: givenURL)
        
        switch result {
        case .success(let itemList):
            XCTAssertTrue(itemList.items.count > 0)
        case .failure(let error):
            XCTAssertEqual("check", error.message)
        }
    }
    
    func test_정상적인url로_items에_100번page로_접근하면_아이템목록이없다() {
        let givenURL = baseURL + "/items/100"
        
        let result = sessionMock.httpGetItems(url: givenURL)
        
        switch result {
        case .success(let itemList):
            XCTAssertTrue(itemList.items.count == 0)
        case .failure(let error):
            XCTAssertEqual("check", error.message)
        }
    }
    
}
