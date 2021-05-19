//
//  NetworkHelperTest.swift
//  OpenMarketTests
//
//  Created by steven on 2021/05/18.
//

import XCTest

@testable import OpenMarket
class NetworkHelperTest: XCTestCase {
    
    func test_상품_목록_요청() {
        let networkHelper = NetworkHelper()
        let pageNum = 1
        
        networkHelper.readList(pageNum: pageNum) { result in
            switch result {
            case .success(let itemsList):
                XCTAssertEqual(itemsList.items.count, 20)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_상품_조회_요청_성공() {
        let networkHelper = NetworkHelper()
        let idNum = 43
        
        networkHelper.readItem(itemNum: idNum) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(item.id, idNum)
            case .failure:
                XCTFail()
            }
        }
    }
    
    func test_상품_조회_요청_실패() {
        let networkHelper = NetworkHelper()
        let idNum = 1
        
        networkHelper.readItem(itemNum: idNum) { result in
            switch result {
            case .success:
                XCTFail()
            case .failure:
                XCTAssert(true)
            }
        }
    }
    
    func test_상품_등록_요청() {
        let form = ItemRegistrationForm(title: "샘플", descriptions: "샘플", price: 100, currency: "KRW", stock: 12, discountedPrice: 99, images: [UIImage(named: "sample")!], password: "1234")
        
        let promise = expectation(description: "form")
        
        NetworkHelper().createItem(itemForm: form) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(form.title, item.title)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
    }
    
    func test_상품_정보_수정_요청() {
        let form = ItemRegistrationForm(title: "이미지수정abc", descriptions: nil, price: nil, currency: nil, stock: nil, discountedPrice: nil, images: [UIImage(named: "vanilla")!], password: "1234")
        let id = 196
        
        let promise = expectation(description: "form")
        
        NetworkHelper().updateItem(itemNum: id, itemForm: form) { result in
            switch result {
            case .success(let item):
                XCTAssertEqual(form.title, item.title)
            case .failure:
                XCTFail()
            }
            promise.fulfill()
        }
        wait(for: [promise], timeout: 5)
        
    }
}
