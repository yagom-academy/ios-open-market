
import XCTest
@testable import OpenMarket

class MockOpenMarketTests: XCTestCase {
    var sut: OpenMarketAPIManager!
    
    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
    }
    
    override func tearDownWithError() throws {
    }
    
    func testFetchProductListofPageOne() {
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(ProductList.self, from: MockAPI.test.sampleItems.data)
        
        sut.fetchProductList(of: 1) { (result) in
            switch result {
            case .success(let productList):
                XCTAssertEqual(productList.items[3].id, response?.items[3].id)
                XCTAssertEqual(productList.items[3].currency, response?.items[3].currency)
                XCTAssertEqual(productList.items[3].price, response?.items[3].price)
                XCTAssertEqual(productList.items[3].discountedPrice, response?.items[3].discountedPrice)
                XCTAssertEqual(productList.items[3].registrationDate, response?.items[3].registrationDate)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testFetchProductListofPageOneFailure() {
        sut = .init(session: MockURLSession(makeRequestFail: true))
        let expectation = XCTestExpectation()
        
        sut.fetchProductList(of: 1) { (result) in
            switch result {
            case .success:
                XCTFail()
            case .failure(let error):
                XCTAssertEqual(error.self, .invalidData)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
}
