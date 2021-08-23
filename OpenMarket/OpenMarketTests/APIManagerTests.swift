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

//    func test_MockAPIManager의fetchProduct가정상호출되면_session의url과전달하는url이같다() throws {
////        guard let url = URL(string: " \(APIManager.shared.baseUrl) + \(APIManager.shared.path) + \(39)") else { return }
////        let url = URL(string: " \(APIManager.shared.baseUrl) + \(APIManager.shared.path) + \(39)")!
////        sut.fetchProduct(id: 1, url: url) { _, _, _ in }
////        XCTAssertEqual(session.url, url)
//
//    }
    
    override func tearDownWithError() throws {
        sut = nil
    }

    

}
