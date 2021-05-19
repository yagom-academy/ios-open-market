//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 배은서 on 2021/05/11.
//

import XCTest
@testable import OpenMarket

final class OpenMarketTests: XCTestCase {
    
    private var client: NetworkManager!
    
    override func setUpWithError() throws {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession(configuration: configuration)
        client = NetworkManager(session: urlSession)
    }
    
    override func tearDownWithError() throws {
        MockURLProtocol.loadingHandler = nil
    }
    
    func testGetItems() {
        guard let url = OpenMarketURL.viewItemList(1).url else { return }
        guard let data = NSDataAsset(name: TestAssets.itemList)?.data else { return }
        guard let decodedData = try? JSONDecoder().decode(ItemList.self, from: data) else { return }
        
        setLoadingHandler(data)
        
        let expectation = XCTestExpectation(description: TestAssets.loadingString)
        
        client.request(ItemList.self, url: url) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, decodedData)
            case .failure(let error):
                XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetItem() {
        guard let url = OpenMarketURL.viewItemDetail(1).url else { return }
        guard let data = NSDataAsset(name: TestAssets.item)?.data else { return }
        guard let decodedData = try? JSONDecoder().decode(ItemResponse.self, from: data) else { return }
        
        setLoadingHandler(data)
        
        let expectation = XCTestExpectation(description: TestAssets.loadingString)
        
        client.request(ItemResponse.self, url: url) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, decodedData)
            case .failure(let error):
                XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeleteItem() {
        guard let url = OpenMarketURL.deleteItem(1).url else { return }
        guard let data = NSDataAsset(name: TestAssets.item)?.data else { return }
        guard let decodedData = try? JSONDecoder().decode(ItemResponse.self, from: data) else { return }
        let deleteBody: ItemForDelete = TestAssets.deleteBody
        
        setLoadingHandler(data)
        
        let expectation = XCTestExpectation(description: TestAssets.loadingString)
        
        client.deleteItem(url: url, body: deleteBody) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, decodedData)
            case .failure(let error):
                XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testPatchItem() {
        guard let url = OpenMarketURL.editItem(1).url else { return }
        let mockData: ItemResponse = TestAssets.mockItemResponse
        guard let encodedMockData: Data = try? JSONEncoder().encode(mockData) else { return }
        let editBody: ItemForEdit = TestAssets.editBody
        
        setLoadingHandler(encodedMockData)
        
        let expectation = XCTestExpectation(description: TestAssets.loadingString)
        
        client.editItem(url: url, body: editBody) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData.title, editBody.title)
                XCTAssertEqual(responseData.descriptions, editBody.descriptions)
            case .failure(let error):
                XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testPostItem() {
        guard let url = OpenMarketURL.registerItem.url else { return }
        let mockData: ItemResponse = TestAssets.mockItemResponse
        guard let encodedMockData = try? JSONEncoder().encode(mockData) else { return }
        let postBody: ItemForRegistration = TestAssets.postBody
        
        setLoadingHandler(encodedMockData)
        
        let expectation = XCTestExpectation(description: TestAssets.loadingString)
        
        client.registerItem(url: url, body: postBody) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData.title, postBody.title)
            case .failure(let error):
                XCTFail("\(TestAssets.requestErrorString + error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
}

extension OpenMarketTests {
    // MARK: - Private Methods for test
    private func setLoadingHandler(_ data: Data) {
        MockURLProtocol.loadingHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            
            return (response, data, nil)
        }
    }
}
