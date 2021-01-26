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
    
    func testItemToGet() {
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
                                    discription: "가장 얇고 가벼운 MacBook이 Apple M1 칩으로 완전히 새롭게 탈바꿈했습니다.",
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

}
