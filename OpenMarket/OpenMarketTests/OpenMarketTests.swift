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
    
    func test_get을_호출시_네트워크_무관_테스트에_성공한다() {
        //given
        let id = 13
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: true), valuableMethod: [.get])
        let expectInputValue = "MockItem"
        guard let jsonData = try? MockJsonDecoder.receiveDataAsset(assetName: expectInputValue) else {
            return
        }
        //when
        let decodedData = try! MockJsonDecoder.decodeJsonFromData(type: ItemData.self, data: jsonData.data)
        sut.commuteWithAPI(API: GetItemAPI(id: id)) { result in
            switch result {
        //then
            case .success(let item):
                guard let expectedData = try? JsonDecoder.decodedJsonFromData(type: ItemData.self, data: item) else {
                    return
                }
                XCTAssertEqual(expectedData.title, decodedData.title)
            case .failure:
                XCTFail()
            }
        }
    }

    func test_get의_Request가_제대로_구성되지않으면_실패한다(){
        //given
        let id = 13
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: true), valuableMethod: [.post])
        
        //when
        sut.commuteWithAPI(API: GetItemAPI(id: id)){ result in
            switch result {
            case .success:
                break
            case .failure(let error):
                //then
                XCTAssertEqual(error as? NetworkError, NetworkError.invalidResult)
            }
        }
    }
    
    func test_get을_호출시_네트워크_무관_테스트에_실패한다() {
        //given
        let id = 13
        let sut = NetworkManager(session: MockURLSession(isRequestSucess: false), valuableMethod: [.get])

        //when
        sut.commuteWithAPI(API: GetItemAPI(id: id)){ result in
            switch result {
            case .success:
                break
            case .failure(let error):
                //then
                XCTAssertEqual(error as? NetworkError, NetworkError.unownedResponse)
            }
        }
    }
}
