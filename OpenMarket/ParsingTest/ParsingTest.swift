//
//  ParsingTest.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/10.
//

import XCTest
@testable import OpenMarket

class ParsingTest: XCTestCase {
    
    class ItemMock: ParsingMock {
        typealias Model = Item
    }
    
    var cutWithItem = ItemMock()
    var listManagingMock = ListManagingMock()
    
    func test_ItemMock에_파일이름으로_item을주면_Item이나온다() {
        let fileName = "item"
        
        let item = try! cutWithItem.parse(about: fileName)
        
        XCTAssertTrue(item is Item)
    }
    
    func test_2번째item을_삭제하면_itemList의_3번째item이_2번째가된다() {
        let itemNumber = 1
        let thirdData = listManagingMock.data?.items[2]
        listManagingMock.delete(itemNumber: itemNumber)
        
        XCTAssertEqual(thirdData, listManagingMock.data?.items[1])
    }
}
