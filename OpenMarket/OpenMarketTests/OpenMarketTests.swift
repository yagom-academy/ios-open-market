//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 배은서 on 2021/05/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        sut = NetworkManager(session: MockURLSession())
    }
    
    func testDataTask() {
        guard let url = OpenMarketURL.viewItemList(1).url else { return }
        let request = URLRequest.set(url: url, httpMethod: .get)
        guard let data = NSDataAsset(name: "items")?.data else { return }
        guard let response = try? JSONDecoder().decode(ItemList.self, from: data) else { return }
        
        sut.dataTask(request, ItemList.self) { result in
            switch result {
            case .success(let itemList):
                XCTAssertEqual(itemList.page, response.page)
                XCTAssertEqual(itemList.items, response.items)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testDataTask_failure() {
        sut = NetworkManager(session: MockURLSession(makeRequestFail: true))
        guard let url = OpenMarketURL.viewItemList(1).url else { return }
        let request = URLRequest.set(url: url, httpMethod: .get)
        
        sut.dataTask(request, ItemList.self) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkFailure(404))
            }
        }
    }
    
    func testRequest() {
        guard let data = NSDataAsset(name: "items")?.data else { return }
        let response = try? JSONDecoder().decode(ItemList.self, from: data)
        
        sut.request(ItemList.self,
                    url: OpenMarketURL.viewItemList(1).url) { result in
            switch result {
            case .success(let itemResponse):
                XCTAssertEqual(itemResponse.page, response?.page)
                XCTAssertEqual(itemResponse.items, response?.items)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testRequest_failure() {
        sut = NetworkManager(session: MockURLSession(makeRequestFail: true))
        
        sut.request(ItemList.self,
                    url: OpenMarketURL.viewItemList(1).url) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkFailure(404))
            }
        }
    }
    
    func testDeleteItem() {
        guard let url = OpenMarketURL.viewItemDetail(1).url else { return }
        let deleteBody = ItemForDelete(password: "Hailey")
        
        guard let data = NSDataAsset(name: "item")?.data else { return }
        let response = try? JSONDecoder().decode(ItemResponse.self, from: data)
        
        sut.deleteItem(url: url,
                       body: deleteBody) { result in
            switch result {
            case .success(let itemResponse):
                XCTAssertEqual(itemResponse.id, response?.id)
                XCTAssertEqual(itemResponse.descriptions, response?.descriptions)
                XCTAssertEqual(itemResponse.images, response?.images)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func testDeleteItem_failure() {
        sut = NetworkManager(session: MockURLSession(makeRequestFail: true))
        guard let url = OpenMarketURL.viewItemDetail(1).url else { return }
        let deleteBody = ItemForDelete(password: "Hailey")
        
        sut.deleteItem(url: url,
                       body: deleteBody) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error, .networkFailure(404))
            }
        }
    }
}
