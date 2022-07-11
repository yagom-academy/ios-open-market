//
//  JsonTest.swift
//  JsonTest
//
//  Created by 허건 on 2022/07/11.
//

import XCTest
@testable import OpenMarket

class JsonTest: XCTestCase {
    var mock: NSDataAsset!
    var jsonDecoder: JSONDecoder!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mock = NSDataAsset.init(name: "products")
        jsonDecoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        mock = nil
        jsonDecoder = nil
    }
    
    func test_MockData_파일의_page_no_값이_디코딩되는지() {
        // given
        let mockInformation = try? jsonDecoder.decode(Network.self, from: mock.data)
        
        // when
        let reult = 1
        
        // then
        XCTAssertEqual(reult, mockInformation?.pageNo)
    }
    
    func test_MockData_파일의_pages_id_값이_디코딩되는지() {
        // given
        let mockInformation = try? jsonDecoder.decode(Network.self, from: mock.data)
        
        // when
        let reult = 20
        
        // then
        XCTAssertEqual(reult, mockInformation?.pages[0].id)
    }
}
