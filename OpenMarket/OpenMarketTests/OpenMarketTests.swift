import XCTest

@testable import OpenMarket

class OpenMarketTests: XCTestCase {

    func testExample() throws {
        let productId = 16
        let url = URL(string: "https://market-training.yagom-academy.kr/api/products/\(productId)")!
        let session = StubURLSession(alwaysSuccess: true)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        session.dataTask(with: request) { data, response, error in
            guard let response = response as? HTTPURLResponse else {
                return
            }
            XCTAssertTrue((200..<300) ~= response.statusCode)
        }.resume()
    }
    
    
    
    
    
}
