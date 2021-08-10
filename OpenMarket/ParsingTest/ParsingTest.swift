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
    
    func test_ItemMock에_파일이름으로_item을주면_Item이나온다() {
        let fileName = "item"
        
        let item = try! cutWithItem.parse(about: fileName)
        
        XCTAssertTrue(item is Item)
    }
}
