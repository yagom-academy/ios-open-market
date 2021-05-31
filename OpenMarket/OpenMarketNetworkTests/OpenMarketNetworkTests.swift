//
//  OpenMarketNetworkTests.swift
//  OpenMarketNetworkTests
//
//  Created by James on 2021/05/31.
//

import XCTest
@testable import OpenMarket
final class OpenMarketNetworkTests: XCTestCase {
    var sut_networkManager: NetworkManager!
    var sut_apiNode: APINode!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut_networkManager = NetworkManager()
        sut_apiNode = APINode()
        
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut_networkManager = nil
        sut_apiNode = nil
    }
    
    func test_getItemList_title() {
        let expectation = XCTestExpectation()

        sut_networkManager.getItemList(node: sut_apiNode, page: 1) { result in
            expectation.fulfill()
            switch result {
            case .success(let itemList):
                XCTAssertEqual(itemList.items[0].title, "MacBook Pro" )
            case .failure(let error):
                XCTFail("\(error)")
            }
        }
        wait(for: [expectation], timeout: 2)
    }

}
