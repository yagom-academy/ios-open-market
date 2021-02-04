//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 임성민 on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    let bundle = Bundle(for: OpenMarketTests.self)

    // MARK:- Decoding & Encoding Test
    func testItem() {
        let fileName = "RetrieveListResponseOneItem"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(Item.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testItemsToGet() {
        let fileName = "RetrieveListResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(ItemsToGet.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testItemToGet() {
        let fileName = "AddRetrieveEditItemResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(ItemToGet.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testServerError() {
        let fileName = "ErrorResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(ServerError.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testItemToDelete() {
        let itemToDelete = ItemToDelete(id: 1, password: "123")
        do {
            let encodedData = try encoder.encode(itemToDelete)
            if let dataString = String(data: encodedData, encoding: .utf8) {
                print(dataString)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testItemAfterDelete() {
        let fileName = "DeleteItemResponse"
        
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("URL Error")
            return
        }
        guard let data = try? Data(contentsOf: url) else {
            XCTFail("Data Error")
            return
        }
        
        do {
            let result = try decoder.decode(ItemAfterDelete.self, from: data)
            print(result)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    // MARK:- Request Test
    
    func testRequestLoadItemList() {
        let testExpectation = XCTestExpectation(description: "LoadItemList 테스트")
        
        OpenMarketAPI.request(.loadItemList(page: 1)) { (result: Result<ItemsToGet, Error>) in
            switch result {
            case .success(let d):
                dump(d)
                testExpectation.fulfill()
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testRequestLoadItem() {
        let id = 31 // 서버에 없는 상품 id 입력시 테스트 실패
        let testExpectation = XCTestExpectation(description: "LoadItem 테스트")
        OpenMarketAPI.request(.loadItem(id: id)) { (result: Result<ItemToGet, Error>) in
            switch result {
            case .success(let d):
                dump(d)
                testExpectation.fulfill()
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testRequestUploadItem() {
        let password = "123"
        let testExpectation = XCTestExpectation(description: "UploadItem 테스트")
        let uiImage1 = UIImage(systemName: "pencil")!
        let uiImage2 = UIImage(systemName: "pencil")!
        let item = ItemToPost(title: "테스트", descriptions: "밤솔", price: 10, currency: "KRW", stock: 10, discountedPrice: 9, images: [uiImage1, uiImage2], password: password)
        
        OpenMarketAPI.request(.uploadItem(item: item)) { (result: Result<ItemAfterPost, Error>) in
            switch result {
            case .success(let d):
                dump(d)
                testExpectation.fulfill()
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testRequestEditItem() {
        let id = 31 // 서버에 없는 상품 id 입력시 테스트 실패
        let password = "123"
        let testExpectation = XCTestExpectation(description: "request 테스트")
        let uiImage = UIImage(systemName: "pencil")!
        let item = ItemToPatch(title: "테스트", descriptions: "솔밤", price: 10, currency: nil, stock: 10, discountedPrice: 9, images: nil, password: password)

        OpenMarketAPI.request(.editItem(id: id, item: item)) { (result: Result<ItemAfterPost, Error>) in
            switch result {
            case .success(let d):
                dump(d)
                testExpectation.fulfill()
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testRequestDeleteItem() {
        let id = 31 // 서버에 없는 상품 id 입력시 테스트 실패
        let password = "123"
        let testExpectation = XCTestExpectation(description: "request 테스트")
        let item = ItemToDelete(id: id, password: password)
        
        OpenMarketAPI.request(.deleteItem(id: id, item: item)) { (result: Result<ItemAfterDelete, Error>) in
            switch result {
            case .success(let d):
                dump(d)
                testExpectation.fulfill()
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        wait(for: [testExpectation], timeout: 5)
    }
}
