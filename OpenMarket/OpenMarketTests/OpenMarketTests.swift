//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by 이예원 on 2021/09/06.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    var productList = [Products]()
    var data: Data!
    let decoder = ParsingManager()
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_MockData와ProductListSearchModel디코딩이성공하면_error를throw하지않는다() throws {
        let url = Bundle.main.url(forResource: "Items", withExtension: "json")!
        data = try Data(contentsOf: url)
        
        XCTAssertNoThrow(try decoder.decode(data, to: Products.self))
    }
    
    func test_네트워킹하지않고fetchProductList함수를호출에성공하면_같은title값이나온다() throws {
        let session = MockURLSession(isRequestSuccess: false)
        let successApiManager = APIManager(session: session)
        successApiManager.fetchProductList(page: 1) { result in
            switch result {
            case .success(let data):
                guard let resultData = try? self.decoder.decode(data, to: Products.self) else {
                    return
                }
                self.productList.append(resultData)
                XCTAssertEqual(self.productList.first?.items[0].title, "MacBook Pro")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func test_네트워킹하지않고fetchProductList함수호출에실패하면_error를throw한다() throws {
        let session = MockURLSession(isRequestSuccess: false)
        let failedApiManager = APIManager(session: session)
        
        failedApiManager.fetchProductList(page: 1) { result in
            switch result {
            case .success(let data):
                guard let resultData = try? self.decoder.decode(data, to: Products.self) else {
                    return
                }
                self.productList.append(resultData)
                XCTAssertEqual(self.productList.first?.items[0].title, "MacBook Pro")
            case .failure(let error):
                let stringError: String = "\(error)"
                XCTAssertEqual(stringError, "requestFailed")
            }
        }
    }
    
    func test_네트워킹하여상품목록을가져오는데성공하면_상품목록페이지가1이나온다() throws {
        let productList = [Products]()
        APIManager.shared.fetchProductList(page: 1) { result in
            switch result {
            case .success(let data):
                guard let resultData = try? self.decoder.decode(data, to: Products.self) else {
                    return
                }
                self.productList.append(resultData)
                XCTAssertEqual(productList.first?.page, 1)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
