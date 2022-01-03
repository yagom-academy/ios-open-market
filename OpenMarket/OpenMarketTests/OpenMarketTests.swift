//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/03.
//

import XCTest

class OpenMarketTests: XCTestCase {
    var sutURLSession: StubURLSession!
    override func setUpWithError() throws {
        let data = NSDataAsset(name: "products")?.data
        guard let url = URL(string: "https://market-training.yagom-academy.kr/") else {
            return
        }
        let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        sutURLSession = StubURLSession(dummy: dummy)
    }

    override func tearDownWithError() throws {
        sutURLSession = nil
    }

    func testExample() throws {
        guard let url = URL(string: "https://market-training.yagom-academy.kr/") else {
            return
        }
        let task = sutURLSession.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            decoder.dateDecodingStrategy = .formatted(dateFormatter)
            guard let data = data else {
                XCTFail()
                return
            }
            do {
                let result = try decoder.decode(Page.self, from: data)
                XCTAssertNotNil(result)
            }
            catch {
                XCTFail()
            }
            
        }
        task.resume()
    }

}
