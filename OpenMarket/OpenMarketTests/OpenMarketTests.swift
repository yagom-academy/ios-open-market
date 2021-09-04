//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이윤주 on 2021/09/03.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func test_success_JSON파일인Item을_Item타입에디코딩하면_title은MacBookPro다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "Item", ofType: "json")
        let jsonFile = try? String(contentsOfFile: path!).data(using: .utf8)
        var outputValue: String?
        //when
        let data = ParsingManager().parse(jsonFile!, to: Item.self)
        switch data {
        case .success(let item):
            outputValue = item.title
        case .failure(let error):
            XCTFail()
        }
        let expectedResultValue = "MacBook Pro"
        //then
        XCTAssertEqual(outputValue, expectedResultValue)
    }
    
    func test_success_JSON파일인Items를_ItemList타입에디코딩하면_items배열의count는20이다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "Items", ofType: "json")
        let jsonFile = try? String(contentsOfFile: path!).data(using: .utf8)
        var outputValue: Int?
        //when
        let data = ParsingManager().parse(jsonFile!, to: ItemList.self)
        switch data {
        case .success(let itemList):
            outputValue = itemList.items.count
        case .failure(let error):
            XCTFail()
        }
        let expectedResultValue = 20
        //then
        XCTAssertEqual(outputValue, expectedResultValue)
    }
    
    func test_fail_JSON파일인Item을_ItemList타입에디코딩하면_디코딩에실패한다() {
        //given
        let path = Bundle(for: type(of: self)).path(forResource: "Item", ofType: "json")
        let jsonFile = try? String(contentsOfFile: path!).data(using: .utf8)
        //when
        let data = ParsingManager().parse(jsonFile!, to: ItemList.self)
        //then
        switch data {
        case .success(let item):
            XCTFail()
        case .failure(let error):
            XCTAssert(true)
        }
    }
    
    func test_success_통신이성공하면_() {
        //given
        let expectation = XCTestExpectation(description: "waitForNetworking")
        let session = MockURLSession(isSuccess: true)
        let networkDispatcher = NetworkDispatcher(session: session)
        var outputValue: Item?
        //when
        networkDispatcher.send(request: Request.getItem, 1) { result in
            switch result {
            case .success(let data):
                let parsedData = ParsingManager().parse(data, to: Item.self)
                switch parsedData {
                case .success(let item):
                    outputValue = item
                case .failure(let error):
                    XCTFail()
                }
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        sleep(5)
        wait(for: [expectation], timeout: 5.0)
        let expectedResultValue = "MacBook Pro"
        //then
        XCTAssertEqual(outputValue?.title, expectedResultValue)
    }
}
