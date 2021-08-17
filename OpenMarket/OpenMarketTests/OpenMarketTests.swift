//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by KimJaeYoun on 2021/08/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    func test_OpenMarketItems의_페이지가_1이다() {
        //given
        let assetData = NSDataAsset(name: "Items")!
        
        //when
        let decodedData = try! ParsingManager.jsonDecode(data: assetData.data, type: OpenMarketItems.self)
        
        //then
        XCTAssertEqual(decodedData.page, 1)
    }
    
    func test_OpenMarketItems의_items배열의첫번째인덱스의id가_1이다() {
        //given
        let assetData = NSDataAsset(name: "Items")!
        
        //when
        let decodedData = try! ParsingManager.jsonDecode(data: assetData.data, type: OpenMarketItems.self)
        
        //then
        XCTAssertEqual(decodedData.items.first?.id, 1)
    }
    
    func test_Item에셋파일을_OpenMarketItems타입으로파싱했을때_id가_1이다() {
        //given
        let assetData = NSDataAsset(name: "Item")!
        
        //when
        let decodedData = try! ParsingManager.jsonDecode(data: assetData.data, type: OpenMarketItems.Item.self)
        
        //then
        XCTAssertEqual(decodedData.id, 1)
    }
    
    func test_Item에셋파일을_OpenMarketItems타입으로파싱했을때_실패한다() {
        //given
        let assetData = NSDataAsset(name: "Items")!
        
        //when
        do {
            _ = try ParsingManager.jsonDecode(data: assetData.data, type: OpenMarketItems.self)
        } catch let error as ParsingError {
            //then
            XCTAssertEqual(error, .decodingError)
        } catch {
        }
    }
}
