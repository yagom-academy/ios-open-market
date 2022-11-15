//
//  ParsingTest.swift
//  ParsingTest
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import XCTest

@testable import OpenMarket
final class ParsingTest: XCTestCase {
    
    var sut: JSONDecoder!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = JSONDecoder()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_json데이터를_정상적으로_모델타입에_맞게_파싱되는지() {
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "products") else { return }
    
        let itemList: ItemList? = try? sut.decode(ItemList.self, from: dataAsset.data)
        
        XCTAssertNotNil(itemList)
    }

}
