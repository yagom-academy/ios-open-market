//
//  OpenMarketJSONTests.swift
//  OpenMarketJSONTests
//
//  Created by SeoDongyeon on 2022/05/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketJSONTests: XCTestCase {
    private var jsonParser: JsonParser!
    private var jsonDecoder: JSONDecoder!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        jsonParser = JsonParser()
        jsonDecoder = JSONDecoder()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        jsonParser = nil
        jsonDecoder = nil
    }

    func test_products_JSON_테스트파일을_decoding해서_결과는_NotNil() {
        // given
        guard let asset = NSDataAsset(name: "products") else {
            XCTFail("File Not Found.")
            return
        }
        print("asset: ",asset)
        
        // when
//        let pageInformation: PageInformation? = jsonParser.decodingJson(json: asset.data)
        let result = try? jsonDecoder.decode(PageInformation.self, from: asset.data)
        print("result: ",result)
        
        // then
        XCTAssertNotNil(result)
    }
}
