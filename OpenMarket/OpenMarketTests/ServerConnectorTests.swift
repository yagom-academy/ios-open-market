//
//  ServerConnectorTests.swift
//  OpenMarketTests
//
//  Created by 김찬우 on 2021/05/21.
//

import XCTest
@testable import OpenMarket

class ServerConnectorTests: XCTestCase {
    func test_getServerData메서드를실행해_원하는객체를_생성할수있는가() {
        func groupForSync() {
            var mockServerConnector = ServerConnector(domain: "https://camp-open-market-2.herokuapp.com/items/1")
            
            mockServerConnector.getServersData()
            sleep(4)
        }
        
        groupForSync()
        XCTAssertEqual(ServedItems.items.page, 1)
    }
}
