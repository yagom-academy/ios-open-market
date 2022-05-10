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
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        jsonParser = JsonParser()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        jsonParser = nil
    }
    
    func test_products_JSON_테스트파일을_decoding해서_결과는_NotNil() {
        // given
        let testFileName = "PageInformationTest"
        let extensionType = "json"
        
        guard let data = load(fileName: testFileName, extensionType: extensionType) else {
            XCTFail()
            return
        }
        
        // when
        let pageInformation: PageInformation? = jsonParser.decodingJson(json: data)
        
        // then
        XCTAssertNotNil(pageInformation)
        XCTAssertNotNil(pageInformation?.pages)
    }
    
    private func load(fileName: String, extensionType: String) -> Data? {
        let testBundle = Bundle(for: type(of: self))
        guard let fileLocation = testBundle.url(forResource: fileName, withExtension: extensionType) else { return nil }
        do {
            let data = try Data(contentsOf: fileLocation)
            return data
        } catch {
            return nil
        }
    }
}

