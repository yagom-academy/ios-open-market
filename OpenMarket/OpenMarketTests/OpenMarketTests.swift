//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by JINHONG AN on 2021/08/12.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    func test_Item에셋파일을_Product타입으로디코딩을하면_타이틀은맥북프로이다() {
        //Given
        let expectInputValue = "Item"
        //When
        let parsedResult = ParsingManager().decode(from: expectInputValue, to: Product.self)
        guard case .success(let outputValue) = parsedResult else {
            return XCTFail()
        }
        let expectResultValue = "MacBook Pro"
        //Then
        XCTAssertEqual(outputValue.title, expectResultValue)
    }
    
    func test_Items에셋파일을_Prodcuts타입으로디코딩을하면_내부Items배열의count는20이다() {
        //Given
        let expectInputValue = "Items"
        //When
        let parsedResult = ParsingManager().decode(from: expectInputValue, to: Products.self)
        guard case .success(let outputValue) = parsedResult else {
            return XCTFail()
        }
        let expectResultValue = 20
        //Then
        XCTAssertEqual(outputValue.items.count, expectResultValue)
    }
    
    func test_1번페이지에대해_리스트를조회했을때_내부아이템의개수는20개이다() {
        //Given
        let pageNum = 1
        let networkManager = NetworkManager(dataTaskRequestable: MockNetworkModule(isSuccessTest: true))
        //When
        var outputValue = 0
        networkManager.lookUpProductList(on: pageNum) { result in
            guard case .success(let resultData) = result,
                  case .success(let products) = ParsingManager().decode(from: resultData, to: Products.self)
            else {
                return XCTFail()
            }
            outputValue = products.items.count
        }
        let expectResultValue = 20
        //Then
        XCTAssertEqual(outputValue, expectResultValue)
    }
    
    func test_맥북프로상품을_등록한뒤에_결과Product의타이틀을확인하면맥북프로이다() {
        //Given
        let itemData: [String : Any] = [
            "title" : "MacBook Pro",
            "description" : "새로나온M1칩이달린노트북입니다.",
            "price" : 1_000_000,
            "currency" : "KRW",
            "stock" : 10,
            "password" : "0000"
        ]
        guard let itemPhoto = Photo(key: "images[]", contentType: .jpegImage, source: #imageLiteral(resourceName: "Retriever")) else {
            return XCTFail("Photo생성 실패")
        }
        let networkManager = NetworkManager(dataTaskRequestable: MockNetworkModule(isSuccessTest: true))
        //When
        var outputValue = ""
        networkManager.registerProduct(with: itemData, and: [itemPhoto]) { result in
            guard case .success(let resultData) = result,
                  case .success(let product) = ParsingManager().decode(from: resultData, to: Product.self)
            else {
                return XCTFail()
            }
            outputValue = product.title
        }
        let expectResultValue = "MacBook Pro"
        //Then
        XCTAssertEqual(outputValue, expectResultValue)
    }
}
