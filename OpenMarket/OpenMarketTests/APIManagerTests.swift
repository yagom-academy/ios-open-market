//
//  APIManagerTests.swift
//  OpenMarketTests
//
//  Created by 이예원 on 2021/08/19.
//

import XCTest
@testable import OpenMarket

class APIManagerTests: XCTestCase {

    var sut: APIManager!
    let session = MockURLSession()
    
    override func setUpWithError() throws {
        sut = APIManager(session: session)
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    

}
