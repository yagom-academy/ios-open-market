//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Seungjin Baek on 2021/05/12.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        let url = Bundle.main.url(forResource: "items", withExtension: ".json")
        guard let dataURL = url, let data = try? Data(contentsOf: dataURL) else {
             return }
        print(data)
        
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
