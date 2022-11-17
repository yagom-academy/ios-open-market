//  Created by Aejong, Tottale on 2022/11/17.

import XCTest
@testable import OpenMarket

final class NetworkTests: XCTestCase {
    
    var sut: NetworkAPIProvider!
    
    override func setUpWithError() throws {
        sut = .init(session: MockURLSession())
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_fetchProductList_success() {
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(ProductList.self,
                                                 from: MockData.sampleData)
        
        sut.fetchProductList(query: nil) { result in
            XCTAssertEqual(result.pageNumber, response?.pageNumber)
            XCTAssertEqual(result.itemsPerPage, response?.itemsPerPage)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
}
