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
            return XCTFail()
        }
        
        //when
        guard let decodedData = try? MockJsonDecoder.decodeJsonFromData(type: ItemsData.self, data: jsonData.data) else {
            return XCTFail()
        }
        let result = decodedData.items[0].title
        let expectResult = "MacBook Pro"
        
        //then
        XCTAssertEqual(result, expectResult)
    }
    
    func test_ItemsData_타입으로_디코딩을_실패한다() {
        //given
        let expectInputValue = "MockItems"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return XCTFail()
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
            return XCTFail()
        }
        
        //when
        guard let decodedData = try? MockJsonDecoder.decodeJsonFromData(type: ItemData.self, data: jsonData.data) else {
            return XCTFail()
        }
        let result = decodedData.title
        let expectResult = "MacBook Pro"
        
        //then
        XCTAssertEqual(result, expectResult)
    }
    
    func test_ItemData_타입으로_디코딩을_실패한다() {
        //given
        let expectInputValue = "MockItem"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return XCTFail()
        }
        
        //when
        do {
            _ = try MockJsonDecoder.decodeJsonFromData(type: ItemData.self, data: jsonData.data)
        } catch let error as JsonError {
            
            //then
            XCTAssertEqual(error, JsonError.decodingFailed)
        } catch { }
    }
    
    func test_get을_호출시_디코드가_성공하고_네트워크_리스폰스를_200번대로_받으면_테스트에_성공한다() {
        //given
        let expectBool = true
        let expectInputValue = "MockItem"
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: expectBool), valuableMethod: [.get])
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return XCTFail()
        }
        
        //when
        guard let decodedData = try? MockJsonDecoder.decodeJsonFromData(type: ItemData.self, data: jsonData.data) else {
            return XCTFail()
        }
        sut.commuteWithAPI(API: GetItemAPI(id: 13)) { result in
            switch result {
            
            //then
            case .success(let item):
                guard let expectedData = try? JsonDecoder.decodedJsonFromData(type: ItemData.self, data: item) else { return }
                XCTAssertEqual(expectedData.title, decodedData.title)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_get의_HTTP메서드가_제대로_구성되지_않으면_테스트에_실패한다() {
        //given
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: false), valuableMethod: [.post])
        
        //when
        sut.commuteWithAPI(API: GetItemAPI(id: 13)){ result in
            if case .failure(let error) = result {
                
                //then
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidResult)
            }
        }
    }
    
    func test_get을_호출시_리스폰스의_상태코드가_402이면_테스트에_실패한다() {
        //given
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: false), valuableMethod: [.get])
        
        //when
        sut.commuteWithAPI(API: GetItemAPI(id: 13)){ result in
            guard case .failure(let error) = result else {
                return XCTFail()
            }
            //then
            XCTAssertEqual(error as? NetworkError, NetworkError.unownedResponse)
        }
    }
}

