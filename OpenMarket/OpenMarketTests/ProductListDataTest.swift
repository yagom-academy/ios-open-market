//
//  ProductListDataTest.swift
//  OpenMarketTests
//  Created by inho, Hamo, Jeremy on 2022/11/15.
//

import XCTest
@testable import OpenMarket

final class ProductListDataTest: XCTestCase {
    var assetData: Data!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let assetName = "products"
        guard let dataAsset = NSDataAsset(name: assetName) else {
            XCTFail("missing file \(assetName).json")
            return
        }
        assetData = dataAsset.data
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        assetData = nil
    }
    
    func test_ProductListData가_json파일의_객체형식과_일치해야한다() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        XCTAssertNoThrow(try jsonDecoder.decode(ProductListData.self, from: self.assetData))
    }
}
