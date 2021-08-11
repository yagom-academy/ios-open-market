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
    
    var cutWithItem: ItemMock!
    var listManagingMock: ListManagingMock!
    
    override func setUp() {
        super.setUp()
        cutWithItem = ItemMock()
        listManagingMock = ListManagingMock()
    }
    
    func test_ItemMock에_파일이름으로_item을주면_Item이나온다() {
        let fileName = "item"
        
        let item = try! cutWithItem.parse(about: fileName)
        
        XCTAssertTrue(item is Item)
    }
    
    func test_n번째item을_삭제하면_itemList의_m번째item이_n번째로당겨진다() {
        let itemNumber = 1
        let thirdData = listManagingMock.data?.items[2]
        listManagingMock.delete(itemNumber: itemNumber)
        
        XCTAssertEqual(thirdData, listManagingMock.data?.items[1])
    }
    
    func test_itemList에서_item을지우면_itemList의_count는감소한다() {
        let initialCount: Int = listManagingMock.data?.items.count ?? 1
        let randomNumber = Int.random(in: 1...initialCount)
        listManagingMock.delete(itemNumber: randomNumber)
        
        XCTAssertEqual(listManagingMock.data?.items.count, initialCount - 1)
    }
}
