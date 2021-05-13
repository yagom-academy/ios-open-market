//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by sookim on 2021/05/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func extractData(_ item: String) -> NSDataAsset? {
        guard let itemData = NSDataAsset(name: item) else {
            return nil
        }
        return itemData
    }
    
    func decodeExtractedData<T: Decodable>(_ object: T.Type, of data: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let contents = try decoder.decode(object, from: data)
            return contents
        } catch {
            return nil
        }
    }
    
    func test_Mock_Item데이터추출() {
        XCTAssertNil(extractData("Itemss"))
    }
    
    func test_Mock_Items데이터추출() {
        XCTAssertNil(extractData("Items"))
    }
    
    func test_Mock_Items디코딩() {
        let extractedData = extractData("Items")
        XCTAssertNil(decodeExtractedData(EntireArticle.self, of: extractedData!.data))
    }
    
    func test_Mock_Item디코딩_withEsstialArticle() {
        let extractedData = extractData("Item")
        XCTAssertNil(decodeExtractedData(EssentialArticle.self, of: extractedData!.data))
    }
    
    func test_Mock_Item디코딩_withDetailArticle() {
        let extractedData = extractData("Item")
        XCTAssertNil(decodeExtractedData(DetailArticle.self, of: extractedData!.data))
    }
    
    func test_추출된데이터확인() {
        let itemData = extractData("Item")
        
        guard let contents = decodeExtractedData(DetailArticle.self, of: itemData!.data) else { XCTFail(); return }
        XCTAssertEqual(contents.id, 1)
        XCTAssertEqual(contents.title, "abc")
        XCTAssertEqual(contents.price, 123)
        XCTAssertEqual(contents.descriptions, "abc")
        XCTAssertEqual(contents.currency, "KRW")
        XCTAssertEqual(contents.stock, 123)
        XCTAssertEqual(contents.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(contents.discountedPrice, 123)
        XCTAssertEqual(contents.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-.png"
        ])
        XCTAssertEqual(contents.registrationDate, 123.12)
    }
}
