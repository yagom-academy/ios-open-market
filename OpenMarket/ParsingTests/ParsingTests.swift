//
//  ParsingTests.swift
//  ParsingTests
//
//  Created by Jpush, Aaron on 2022/11/14.
//

import XCTest

final class ParsingTests: XCTestCase {
    
    func test_json파일을_파싱_했을_때_잘_되는지() {
        // given
        guard let json = NSDataAsset(name: "products.json") else {
            return
        }
        
        // when
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SS"
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(dateFormater)
        
        let data = json.data

        guard let result = try? decoder.decode(ProductsList.self, from: data) else {
            return
        }
        
        // then
        XCTAssertNotNil(result)
    }
}
