//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 배은서 on 2021/05/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    func testRequestItemList_itemURL을주었을때_data를print한다() {
        let dataManager = DataManager()
        
        dataManager.requestItemList(url: "https://camp-open-market-2.herokuapp.com/items/1")
    }

}
