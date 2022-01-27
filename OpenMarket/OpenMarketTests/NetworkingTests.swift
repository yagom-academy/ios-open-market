import XCTest

@testable import OpenMarket

class NetworkingTests: XCTestCase {
    
    func test_1번페이지에_첫번째_상품의_id는_20이다() {
        let data = NSDataAsset(name: "products")
        let testSession = StubURLSession(alwaysSuccess: true, dummyData: data?.data)

        NetworkingAPI.ProductListQuery.request(session: testSession,
                                               pageNo: 1,
                                               itemsPerPage: 15) { result in
            
            switch result {
            case .success(let data):
                let products = NetworkingAPI.ProductListQuery.decode(data: data)
                XCTAssertEqual(products?.pages[0].id, 20)
            case .failure:
                XCTAssertTrue(false)
            }
        }
    }
}
