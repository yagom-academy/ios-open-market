import XCTest

@testable import OpenMarket

class NetworkingTests: XCTestCase {
    
    func test_1번페이지에_첫번째_상품의_id는_20이다() {
        let data = NSDataAsset(name: "products")
        let testSession = StubURLSession(alwaysSuccess: true, dummyData: data?.data)
        let requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 20)
        
        testSession.request(requester: requester) {result in
            switch result {
            case .success(let data):
                let products = requester.decode(data: data)
                XCTAssertEqual(products?.pages[0].id, 20)
            case .failure:
                XCTAssertTrue(false)
            }
        }
    }
    
    func test_temp() {
        print(Temp().toRedStrikeThrough(from: "abc"))
        print(Temp().toRedStrikeThrough2(from: "def"))
    }
}
