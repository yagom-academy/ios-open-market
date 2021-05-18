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
    
    override class func tearDown() {
        MockURLProtocol.loadingHandler = nil
    }
    
    func testGetItems() {
        guard let url = OpenMarketURL.viewItemList(1).url else { return }
        guard let data = NSDataAsset(name: "Items")?.data else { return }
        guard let decodedData = try? JSONDecoder().decode(ItemList.self, from: data) else { return }
        
        setLoadingHandler(data)
        
        let expectation = XCTestExpectation(description: "Loading")
        
        client.request(ItemList.self, url: url) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, decodedData)
            case .failure(let error):
                XCTFail("Request was not successful: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetItem() {
        guard let url = OpenMarketURL.viewItemDetail(1).url else { return }
        guard let data = NSDataAsset(name: "Item")?.data else { return }
        guard let decodedData = try? JSONDecoder().decode(ItemResponse.self, from: data) else { return }
        
        setLoadingHandler(data)
        
        let expectation = XCTestExpectation(description: "Loading")
        
        client.request(ItemResponse.self, url: url) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, decodedData)
            case .failure(let error):
                XCTFail("Request was not successful: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testDeleteItem() {
        guard let url = OpenMarketURL.deleteItem(1).url else { return }
        guard let data = NSDataAsset(name: "Item")?.data else { return }
        guard let decodedData = try? JSONDecoder().decode(ItemResponse.self, from: data) else { return }
        
        let deleteBody = ItemForDelete(password: "1234")
        
        setLoadingHandler(data)
        
        let expectation = XCTestExpectation(description: "Loading")
        
        client.deleteItem(url: url, body: deleteBody) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData, decodedData)
            case .failure(let error):
                XCTFail("Request was not successful: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testEditItem() {
        guard let url = OpenMarketURL.editItem(1).url else { return }
        
        let mockData = ItemResponse(
            id: 1,
            title: "pencil",
            descriptions: "apple pencil",
            price: 1690000,
            currency: "KRW",
            stock: 1000000000000,
            discountedPrice: nil,
            thumbnails: [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
        ],
            images: [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ],
            registrationDate: 1611523563.719116
        )
        guard let encodedMockData = try? JSONEncoder().encode(mockData) else { return }
        
        let editBody = ItemForEdit(
            title: "pencil",
            price: nil,
            descriptions: "apple pencil",
            currency: nil,
            stock: nil,
            discountedPrice: nil,
            images: nil,
            password: ""
        )
        
        setLoadingHandler(encodedMockData)
        
        let expectation = XCTestExpectation(description: "Loading")
        
        client.editItem(url: url, body: editBody) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData.title, editBody.title)
                XCTAssertEqual(responseData.descriptions, editBody.descriptions)
            case .failure(let error):
                XCTFail("Request was not successful: \(error.localizedDescription)")
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1)
    }
    
    func testPostItem() {
        guard let url = OpenMarketURL.registerItem.url else { return }
        
        let mockData = ItemResponse(
            id: 1,
            title: "pencil",
            descriptions: "apple pencil",
            price: 1690000,
            currency: "KRW",
            stock: 1000000000000,
            discountedPrice: nil,
            thumbnails: [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-2.png"
        ],
            images: [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-1.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ],
            registrationDate: 1611523563.719116
        )
        guard let encodedMockData = try? JSONEncoder().encode(mockData) else { return }
        
        guard let image = UIImage(named: "test_image")?.pngData() else { return }
        
        let postBody = ItemForRegistration(
            title: "pencil",
            descriptions: "apple pencil",
            price: 1690000,
            currency: "KRW",
            stock: 1000000000000,
            discountedPrice: nil,
            images: [image],
            password: "1234"
        )
        
        setLoadingHandler(encodedMockData)
        
        let expectation = XCTestExpectation(description: "Loading")
        
        client.registerItem(url: url, body: postBody) { result in
            switch result {
            case .success(let responseData):
                XCTAssertEqual(responseData.title, postBody.title)
            case .failure(let error):
                XCTFail("Request was not successful: \(error.localizedDescription)")
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
