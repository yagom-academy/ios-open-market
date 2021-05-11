//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by TORI on 2021/05/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_URL요청하기() {
        let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1")
        let response = try? String(contentsOf: url!)
        XCTAssertNotNil(response)
    }
    
    func test_아이템을_받아왔는지_확인() {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1") else {
            XCTFail()
            return
        }
        guard let data = try? String(contentsOf: url).data(using: .utf8) else {
            XCTFail()
            return
        }
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(OpenMarketItemsList.self, from: data) else {
            XCTFail()
            return
        }
        print("Hello111")
        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.items.count, 20)
        XCTAssertEqual(result.items[0].id, 43)
        XCTAssertEqual(result.items[0].stock, 5000000)
        XCTAssertEqual(result.items[0].currency, "USD")
        XCTAssertEqual(result.items[0].title, "Apple Pencil")
        XCTAssertEqual(result.items[0].price, 165)
        XCTAssertEqual(result.items[0].discounted_price, 160)
        XCTAssertEqual(result.items[0].registration_date, 1620633347.3906322)
    }
    
    func test_상품_등록_폼_인스턴스를_Json으로_변환() {
        let form = ItemRegistrationForm(title: "m2맥북", descriptions: "빨리나와", price: 1999, currency: "USD", stock: 100, discounted_price: 1800, images: ["hello"], password: "1234")
        let encoder = JSONEncoder()
        let resultJson = """
        {"images":["hello"],"password":"1234","discounted_price":1800,"price":1999,"stock":100,"title":"m2맥북","descriptions":"빨리나와","currency":"USD"}
        """
        
        guard let jsonData = try? encoder.encode(form) else { XCTFail(); return }
        
        guard let jsonString = String(data: jsonData, encoding: .utf8) else { XCTFail(); return}
        XCTAssertEqual(jsonString, resultJson)
    }
    
    func test_Http_DELETE_메소드_보내기() {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/item/77")
        else { XCTFail(); return }
        
        let promise = expectation(description: "Status code: 200")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = "{ \"password\": \"123\" }".data(using: .utf8)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                XCTAssertEqual(statusCode, 200)
                promise.fulfill()
            }
        }.resume()
        
        wait(for: [promise], timeout: 2)
    }
}
