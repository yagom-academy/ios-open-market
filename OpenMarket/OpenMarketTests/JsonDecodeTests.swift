//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 임지성 on 2022/01/03.
//

import XCTest
@testable import OpenMarket

class JsonDecodeTests: XCTestCase {
    func test_json파일이_정상적으로_디코딩되는지() {
        let data = Bundle.main.path(forResource: "products", ofType: "json")
        
        let jsonData = try! String(contentsOfFile: data!).data(using: .utf8)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        
        let result = try! decoder.decode(ProductList.self, from: jsonData!)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SS"
        let convertedDate = dateFormatter.string(from: result.pages.first!.createdAt)
    
        XCTAssertEqual(convertedDate, "2022-01-03 00:00:00.00")
        XCTAssertEqual(result.pages.first?.currency, .krw)
        XCTAssertEqual(result.pageNo, 1)
    }
}
