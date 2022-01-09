import XCTest

@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    func test_1번페이지에_첫번째_상품의_id는_20이다() {
        let data = NSDataAsset(name: "products")
        let testSession = StubURLSession(alwaysSuccess: true, dummyData: data?.data)
        let requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 20)
        
        testSession.request(urlRequest: requester.request!) { result in
            switch result {
            case .success(let data):
                let products = requester.decode(data: data, expecting: ProductListAsk.Response.self)
                XCTAssertEqual(products?.pages[0].id, 20)
            case .failure:
                XCTAssertTrue(false)
            }
        }
    }
}
