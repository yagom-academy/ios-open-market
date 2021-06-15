import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    // MARK:- Tool for test preparation
    func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // FIXME: - print 안됨
    func test_ItemListFetcher() throws {
        let networkManager = NetworkManager()
        let expectation = XCTestExpectation(description: "expectation")
        networkManager.fetchItemList(completion: { itemList in
            print(itemList)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 10.0)
    }
}
