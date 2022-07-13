import XCTest

@testable import OpenMarket
class JsonParsingTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }
    
    override func tearDownWithError() throws {
        
    }
    
    func test_데이터를파싱했을때_pageNo값이잘들어오는지() {
        // given
        guard let fileLocation = Bundle.main.url(forResource: "products", withExtension: "json"), let data = try? Data(contentsOf: fileLocation) else {
            XCTFail()
            return
        }
        
        let expression = 1
        // when
        guard let parsedData = try? JSONDecoder().decode(Products.self, from: data) else {
            XCTFail()
            return
        }
        // then
        XCTAssertEqual(parsedData.pageNo, expression)
    }
    
    func test_데이터를파싱했을때_pages값이잘들어오는지1() {
        // given
        guard let fileLocation = Bundle.main.url(forResource: "products", withExtension: "json"), let data = try? Data(contentsOf: fileLocation) else {
            XCTFail()
            return
        }
        
        let expression = 20
        // when
        guard let parsedData = try? JSONDecoder().decode(Products.self, from: data) else {
            XCTFail()
            return
        }
        // then
        XCTAssertEqual(parsedData.pages[0].id, expression)
    }
    
    func test_데이터를파싱했을때_pages값이잘들어오는지2() {
        // given
        guard let fileLocation = Bundle.main.url(forResource: "products", withExtension: "json"), let data = try? Data(contentsOf: fileLocation) else {
            XCTFail()
            return
        }
        
        
        let expression = "2022-01-04T00:00:00.00"
        // when
        guard let parsedData = try? JSONDecoder().decode(Products.self, from: data) else {
            XCTFail()
            return
        }
        // then
        XCTAssertEqual(parsedData.pages[0].issuedAt, expression)
    }
}
