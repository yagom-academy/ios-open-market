//
//  RequestTest.swift
//  RequestTest
//
//  Created by kjs on 2021/08/23.
//

import XCTest
@testable import OpenMarket

class RequestTest: XCTestCase {
    let commonPassword = "test"
    
    var session: ClientAPI!
    
    override func setUp() {
        super.setUp()
        
        session = Session()
    }
    
    override func tearDown() {
        super.tearDown()
        
        session = nil
    }
    
    func test_POST() {
        let dummy = ItemRequestable(
            title:"테스트 인스턴스",
            descriptions: "비밀번호는 test",
            price: 1000,
            currency: "KRW",
            stock: 999_9999_9999,
            discountedPrice: 900,
            password: commonPassword)
        Session().postItem(item: dummy, images: [#imageLiteral(resourceName: "compressed")]) { result in
            switch result {
            case .success(let itemDetail):
                print(itemDetail)
            case .failure(let error):
                print(error)
            }
        }
    }
}
