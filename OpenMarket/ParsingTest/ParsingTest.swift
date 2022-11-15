//
//  ParsingTest.swift
//  ParsingTest
//
//  Created by 노유빈 on 2022/11/15.
//

import XCTest

@testable import OpenMarket
final class ParsingTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_json데이터를_정상적으로_모델타입에_맞게_파싱되는지() throws {
        let jsonDecoder: JSONDecoder = JSONDecoder()
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "products") else { return }
        
        do {
            let itemList: ItemList? = try jsonDecoder.decode(ItemList.self, from: dataAsset.data)
        } catch error {
            print(error)
        }
        
        //let itemList: ItemList? = try? jsonDecoder.decode(ItemList.self, from: dataAsset.data)
        XCTAssertNotNil(itemList)
    }

}
