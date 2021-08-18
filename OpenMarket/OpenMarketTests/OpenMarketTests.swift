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
    
    func test_getItems를_네트워크_무관_테스트에_성공한다() {
        //given
        let page = "1"
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: true))
        let expectInputValue = "MockItems"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return
        }
        //when
        let decodedData = try! MockJsonDecoder.decodeJsonFromData(type: ItemsData.self, data: jsonData.data)
        sut.getItems(page: page) { result in
            switch result {
        //then
            case .success(let item):
                XCTAssertEqual(item.items[0].title, decodedData.items[0].title)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_getItems를_네트워크_무관_테스트에_실패한다() {
        //given
        let page = "1"
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: true))
        
        //when
        sut.getItems(page: page) { result in
            switch result {
            //then
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, "unknownError")
            }
        }
    }
}
