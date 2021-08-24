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
    
    var session: ClientAPI!
    
    override func setUp() {
        super.setUp()
        
        session = NetworkManager()
    }
    
    override func tearDown() {
        super.tearDown()
        
        session = nil
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
}
