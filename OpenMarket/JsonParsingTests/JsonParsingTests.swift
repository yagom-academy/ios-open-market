import XCTest

class JsonParsingTests: XCTestCase {
    
    override func setUpWithError() throws {
        
    }

    override func tearDownWithError() throws {
        
    }

    func test_데이터를파싱했을때_pageNo값이잘들어오는지() {
        // given
        let expression = 1
        // when
        let data = try! JSONDecoder().decode(Products.self, from: productsJson!)
        // then
        XCTAssertEqual(data.pageNo, expression)
    }
    
    func test_데이터를파싱했을때_pages값이잘들어오는지1() {
        // given
        let expression = 20
        // when
        let data = try! JSONDecoder().decode(Products.self, from: productsJson!)
        // then
        XCTAssertEqual(data.pages[0].id, expression)
    }
    
    func test_데이터를파싱했을때_pages값이잘들어오는지2() {
        // given
        let expression = "2022-01-04T00:00:00.00"
        // when
        let data = try! JSONDecoder().decode(Products.self, from: productsJson!)
        // then
        XCTAssertEqual(data.pages[0].issuedAt, expression)
    }
}
