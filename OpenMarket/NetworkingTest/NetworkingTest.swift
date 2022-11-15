//
//  NetworkingTest.swift
//  NetworkingTest
//
//  Created by 스톤, 로빈 on 2022/11/15.
//

import XCTest

@testable import OpenMarket
final class NetworkingTest: XCTestCase {
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkManager()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }

    func test_ItemList를_정상적으로_받아오는지() {
        var itemList: ItemList?
        sut.fetchItemList { list in
            itemList = list
        }
        
        print(itemList)
    }

}
