//  Created by Aejong, Tottale on 2022/11/17.

import XCTest
@testable import OpenMarket

final class NetworkTests: XCTestCase {
    
    var sut: NetworkAPIProvider!
    let sampleData = MockData.sampleData
    
    override func setUpWithError() throws {
        sut = .init(session: MockURLSession(sampleData: sampleData))
    }
    
    override func tearDownWithError() throws {
        sut = nil
    }
    
    func test_fetchProductList_success() {
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(ProductList.self,
                                                 from: sampleData)
        
        sut.fetchProductList(query: nil) { result in
            switch result {
            case .failure:
                XCTFail()
            case .success(let productList):
                XCTAssertEqual(productList.pageNumber, response?.pageNumber)
                XCTAssertEqual(productList.itemsPerPage, response?.itemsPerPage)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
}
