import XCTest
@testable import OpenMarket

class OpenMarketParsingTests: XCTestCase {

    func test_ProductPageHTTPResponse가_정상적으로_디코딩되는지() throws {
        guard let data = NSDataAsset(name: "products") else {
            XCTAssertTrue(false)
            return
        }
        guard let decodedData = try? JSONDecoder().decode(ProductListAsk.Response.self, from: data.data) else {
            XCTAssertTrue(false)
            return
        }
        XCTAssertEqual(decodedData.pages.first?.id, 20)
    }
}
