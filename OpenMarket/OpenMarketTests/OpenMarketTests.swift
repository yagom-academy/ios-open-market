//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 박태현 on 2021/08/11.
//

import XCTest
@testable import OpenMarket
class OpenMarketTests: XCTestCase {
 
    func test_ItemsData_타입으로_디코딩을_성공한다() {
        //given
        let expectInputValue = "MockItems"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return
        }
        
        //when
        let decodedData = try! MockJsonDecoder.decodeJsonFromData(type: ItemsData.self, data: jsonData.data)
        let result = decodedData.items[0].title
        let expectResult = "MacBook Pro"
        
        //then
        XCTAssertEqual(result, expectResult)
    }
    
    func test_ItemsData_타입으로_디코딩을_실패한다() {
        //given
        let expectInputValue = "MockItems"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return
        }
        
        //when
        do {
            _ = try MockJsonDecoder.decodeJsonFromData(type: ItemsData.self, data: jsonData.data)
        } catch let error as JsonError {
            //then
            XCTAssertEqual(error, JsonError.decodingFailed)
        } catch { }
    }


    func test_ItemData_타입으로_디코딩을_성공한다() {
        //given
        let expectInputValue = "MockItem"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return
        }
        
        //when
        let decodedData = try! MockJsonDecoder.decodeJsonFromData(type: ItemData.self, data: jsonData.data)
        let result = decodedData.title
        let expectResult = "MacBook Pro"
        
        //then
        XCTAssertEqual(result, expectResult)
    }


    func test_ItemData_타입으로_디코딩을_실패한다() {
        //given
        let expectInputValue = "MockItem"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return
        }
        
        //when
        do {
            _ = try MockJsonDecoder.decodeJsonFromData(type: ItemData.self, data: jsonData.data)
        } catch let error as JsonError {
            //then
            XCTAssertEqual(error, JsonError.decodingFailed)
        } catch { }
    }
}
