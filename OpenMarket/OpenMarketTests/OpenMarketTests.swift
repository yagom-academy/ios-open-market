//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Gundy, Wonbi on 2022/11/15.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var sut: JSONDecoder!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = JSONDecoder()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        sut = nil
    }
}
