//
//  NetworkTest.swift
//  NetworkTest
//
//  Created by kjs on 2021/08/23.
//

import XCTest
@testable import OpenMarket

class NetworkTest: XCTestCase {
    let commonPassword = "test"
    
    var session: API!
    
    override func setUp() {
        super.setUp()
        
        session = NetworkManager()
    }
    
    override func tearDown() {
        super.tearDown()

        session = nil
    }
    
    func test_getItems를통해_1번페이지를가져오면_상품들이존재한다() {
        //given
        let pageIndex: UInt = 1
        
        //when
        var beResult: Result<GoodsList, HttpError>?
        let exception = XCTestExpectation(description: "response")
        session.getItems(pageIndex: pageIndex) { result in
            beResult = result
            exception.fulfill()
        }
        wait(for: [exception], timeout: 5)
        
        //then
        switch beResult {
        case .none:
            XCTFail()
        case .failure:
            XCTFail()
        case .success(let goodsList):
            XCTAssertTrue(goodsList.items.count > 0)
        }
    }
    
    func test_getItems를통해_100번페이지를가져오면_상품이아직존재하지않는다() {
        //given
        let pageIndex: UInt = 100
        
        //when
        var beResult: Result<GoodsList, HttpError>?
        let exception = XCTestExpectation(description: "response")
        session.getItems(pageIndex: pageIndex) { result in
            beResult = result
            exception.fulfill()
        }
        wait(for: [exception], timeout: 5)
        
        //then
        switch beResult {
        case .none:
            XCTFail()
        case .failure:
            XCTFail()
        case .success(let goodsList):
            XCTAssertTrue(goodsList.items.count == 0)
        }
    }
    
    func test_post메소드의가격에_랜덤한숫자를집어넣으면_결과도_그랜덤한숫자다() {
        //given
        let randomPrice = Int.random(in: 1000...10000)
        let imageLiteral = #imageLiteral(resourceName: "compressed")
        let dummy = ItemRequestable(
            title:"테스트 인스턴스",
            descriptions: "비밀번호는 test",
            price: randomPrice,
            currency: "KRW",
            stock: 999_9999_9999,
            discountedPrice: 900,
            password: commonPassword
        )
        var beResult: Result<ItemDetail, HttpError>?
        
        //when
        let exception = XCTestExpectation(description: "response")
        NetworkManager().postItem(item: dummy, images: [imageLiteral]) { result in
            beResult = result
            exception.fulfill()
        }
        wait(for: [exception], timeout: 5)
        
        //then
        switch beResult {
        case .none:
            XCTFail()
        case .success(let itemDetail):
            XCTAssertEqual(itemDetail.price, randomPrice)
        case .failure:
            XCTFail()
        }
    }
    
    
    func test_post메소드에_타이틀을누락하고요청하면_에러가발생한다() {
        //given
        let randomPrice = Int.random(in: 1000...10000)
        let imageLiteral = #imageLiteral(resourceName: "compressed")
        let dummy = ItemRequestable(
            descriptions: "비밀번호는 test",
            price: randomPrice,
            currency: "KRW",
            stock: 999_9999_9999,
            discountedPrice: 900,
            password: commonPassword
        )
        var beResult: Result<ItemDetail, HttpError>?
        
        //when
        let exception = XCTestExpectation(description: "response")
        NetworkManager().postItem(item: dummy, images: [imageLiteral]) { result in
            beResult = result
            exception.fulfill()
        }
        wait(for: [exception], timeout: 5)
        
        //then
        switch beResult {
        case .none:
            XCTFail()
        case .success:
            XCTFail()
        case .failure(let error):
            XCTAssertEqual(error.errorDescription, Parser.ErrorCases.decodable)
        }
    }
}
