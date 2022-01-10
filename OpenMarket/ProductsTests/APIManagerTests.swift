import XCTest

class APIManagerTests: XCTestCase {
    var sut: APIManager!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = APIManager()
    }
    
    func test_healthChecker가_API통신성공시_data값이_OK인지() {
        let expectation = XCTestExpectation(description: "healthCheckerTest")
        sut.requestHealthChecker { result in
            switch result {
            case .success(let data):
                let health = String(data: data, encoding: .utf8)
                XCTAssertEqual(health, "\"OK\"")
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func test_productInformation의_id가_13일때_name의_값이_팥빙수인지() {
        let expectation = XCTestExpectation(description: "requestProductInformationTest")
        sut.requestProductInformation(productID: 13) { result in
            switch result {
            case .success(let data):
                let name = data.name
                XCTAssertEqual(name, "팥빙수")
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

    func test_productList의_limit의_값이_20인지() {
        let expectation = XCTestExpectation(description: "requestProductListTest")
        sut.requestProductList(pageNumber: 1, itemsPerPage: 20) { result in
            switch result {
            case .success(let data):
                let limit = data.limit
                XCTAssertEqual(limit, 20)
            case .failure(_):
                XCTFail()
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
}
