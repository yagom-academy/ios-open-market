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
    
    func testItemToPost() {
        let image = UIImage(systemName: "pencil")
        guard let imageData = image?.jpegData(compressionQuality: 1) else {
            return
        }
        let itemToPost = ItemToPost(title: "MacBook Air",
                                    descriptions: "가장 얇고 가벼운 MacBook이 Apple M1 칩으로 완전히 새롭게 탈바꿈했습니다.",
                                    price: 1290000,
                                    currency: "KRW",
                                    stock: 10000,
                                    discountedPrice: 10000,
                                    images: [imageData],
                                    password: "123")
        do {
            let encodedData = try encoder.encode(itemToPost)
            if let dataString = String(data: encodedData, encoding: .utf8) {
                print(dataString)
            }
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
    
    func testItemToPatch() {
        let image = UIImage(systemName: "pencil")
        guard let imageData = image?.jpegData(compressionQuality: 1) else {
            return
        }
        let itemToPatch = ItemToPatch(title: "MacBook Air",
                                      discription: "가장 얇고 가벼운 MacBook이 Apple M1 칩으로 완전히 새롭게 탈바꿈했습니다.",
                                      price: 1290000,
                                      currency: "KRW",
                                      stock: 10000,
                                      discountedPrice: nil,
                                      images: [imageData],
                                      password: "123")
        do {
            let encodedData = try encoder.encode(itemToPatch)
            if let dataString = String(data: encodedData, encoding: .utf8) {
                print(dataString)
            }
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
    
    func testMakeURLTypeGetList() {
        let url = URLManager.makeURL(type: .getItemList, value: 1)
        let RealURL = URL(string: "https://camp-open-market.herokuapp.com/items/1")
        
        XCTAssertEqual(url, RealURL, "URL이 잘못되었습니다.")
    }
    
    func testMakeURLTypeGetItem() {
        let url = URLManager.makeURL(type: .getItem, value: 1)
        let RealURL = URL(string: "https://camp-open-market.herokuapp.com/item/1")
        
        XCTAssertEqual(url, RealURL, "URL이 잘못되었습니다.")
    }
    
    func testMakeURLTypePostItem() {
        let url = URLManager.makeURL(type: .postItem, value: nil)
        let RealURL = URL(string: "https://camp-open-market.herokuapp.com/item")
        
        XCTAssertEqual(url, RealURL, "URL이 잘못되었습니다.")
    }
    
    func testMakeURLTypePatchItem() {
        let url = URLManager.makeURL(type: .patchItem, value: 2)
        let RealURL = URL(string: "https://camp-open-market.herokuapp.com/item/2")
        
        XCTAssertEqual(url, RealURL, "URL이 잘못되었습니다.")
    }
    
    func testMakeURLTypeDeleteItem() {
        let url = URLManager.makeURL(type: .deleteItem, value: 3)
        let RealURL = URL(string: "https://camp-open-market.herokuapp.com/item/3")
        
        XCTAssertEqual(url, RealURL, "URL이 잘못되었습니다.")
    }
    
    func testGetItems() {
        let testExpectation = XCTestExpectation(description: "getItemList 테스트")
        var itemToGet: ItemsToGet?
        OpenMarketAPI.getItemList(page: 1) { (itemList) in
            itemToGet = itemList
            if itemToGet == nil {
                return
            }
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: 5)
    }
    
    func testPostItem() {
        let testExpectation = XCTestExpectation(description: "postItem 테스트")
        let uiImage = UIImage(systemName: "pencil")
        guard let imageData = uiImage?.pngData() else {
            return
        }
        let itemToPost = ItemToPost(title: "테스트", descriptions: "밤, 솔", price: 100, currency: "KRW", stock: 100, discountedPrice: 90, images: [imageData], password: "123")
        var itemAfterPost: ItemAfterPost?
        OpenMarketAPI.postItem(itemToPost: itemToPost) { (item) in
            itemAfterPost = item
            if itemAfterPost == nil {
                print("itemAfterPost가 nil입니다.")
                return
            }
            testExpectation.fulfill()
        }
        wait(for: [testExpectation], timeout: 5)
    }

}
