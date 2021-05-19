//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 윤재웅 on 2021/05/12.
//

import XCTest
@testable import OpenMarket


class OpenMarketTests: XCTestCase {
    let mockItems = NSDataAsset(name: "Items")!.data
    let mockItem = NSDataAsset(name: "Item")!.data
    let client = MockMarketNetworkManager()
    var dummyPostItem: ItemUpload?
    var dummyPatchItem: ItemDetailUpload?
    let encode = JSONEncoder()

    override func setUpWithError() throws {
        dummyPostItem = ItemUpload(title: "Tak",
                                   descriptions: "탁탁탁",
                                   price: 500,
                                   currency: "KOR",
                                   stock: 2,
                                   discountedPrice: 200,
                                   images: [],
                                   password: "1234")
        dummyPatchItem = ItemDetailUpload(title: "Fezz",
                                          descriptions: "페즈페즈",
                                          price: nil,
                                          currency: nil,
                                          stock: 1,
                                          discountedPrice: nil,
                                          images: nil,
                                          password: "1234")
        
    }

    override func tearDownWithError() throws {

    }
    
    func test_MarketItems_Decode_성공() {
        XCTAssertNotNil(try? JSONDecoder().decode(MarketItems.self, from: mockItems))
        
    }
    
    func test_MarketItem_Decode_성공() {
        XCTAssertNotNil(try? JSONDecoder().decode(MarketItem.self, from: mockItem))
    }
    
    func test_network_excute_GET_목록조회_called() {
        let sut = MarketNetworkManager(client: client)
        
        var request = URLRequest(url: URL(string: MarketAPI.baseURL + MarketAPI.Path.items.route)!)
        request.httpMethod = "GET"
        
        sut.excute(request: request, decodeType: MarketItems.self) { _ in }

        XCTAssertTrue(client.executeCalled)
    }
    
    func test_network_excute_GET_상품조회_called() {
        let sut = MarketNetworkManager(client: client)
        
        var request = URLRequest(url: URL(string: MarketAPI.baseURL + MarketAPI.Path.item.route)!)
        request.httpMethod = "GET"
        
        sut.excute(request: request, decodeType: MarketItem.self) { _ in }

        XCTAssertTrue(client.executeCalled)
    }
    
    func test_network_excute_POST_상품등록_called() {
        let sut = MarketNetworkManager(client: client)
        do {
            let jsonData = try encode.encode(dummyPatchItem)
            var request = URLRequest(url: URL(string: MarketAPI.baseURL + MarketAPI.Path.registrate.route)!)
            request.httpMethod = "POST"
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            sut.excute(request: request, decodeType: MarketItem.self) { _ in }
        } catch {
            XCTFail()
        }

        XCTAssertTrue(client.executeCalled)
    }
    
    func test_network_excute_POST_상품삭제_called() {
        let sut = MarketNetworkManager(client: client)
        
        var request = URLRequest(url: URL(string: MarketAPI.baseURL + MarketAPI.Path.delete.route)!)
        request.httpMethod = "POST"

        sut.excute(request: request, decodeType: MarketItem.self) { _ in }
        
        XCTAssertTrue(client.executeCalled)
    }
    
    func test_network_excute_PATCH_상품수정_called() {
        let sut = MarketNetworkManager(client: client)
        
        do {
            let jsonData = try encode.encode(dummyPatchItem)
            var request = URLRequest(url: URL(string: MarketAPI.baseURL + MarketAPI.Path.edit.route)!)
            request.httpMethod = "PATCH"
            request.setValue("multipart/form-data", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData
            sut.excute(request: request, decodeType: MarketItem.self) { _ in }
        } catch {
            XCTFail()
        }

        XCTAssertTrue(client.executeCalled)
    }
}
