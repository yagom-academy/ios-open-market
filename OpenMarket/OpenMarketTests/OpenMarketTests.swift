//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by TORI on 2021/05/10.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    func test_URL요청하기() {
        let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1")
        let response = try? String(contentsOf: url!)
        XCTAssertNotNil(response)
        
    }
    
    func test_상품목록을_조회해서_itemList로_변환하기() {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/items/1") else {
            XCTFail()
            return
        }
        guard let data = try? String(contentsOf: url).data(using: .utf8) else {
            XCTFail()
            return
        }
        let decoder = JSONDecoder()
        guard let result = try? decoder.decode(ProductList.self, from: data) else {
            XCTFail()
            return
        }

        XCTAssertEqual(result.page, 1)
        XCTAssertEqual(result.items.count, 20)
        XCTAssertEqual(result.items[0].id, 43)
        XCTAssertEqual(result.items[0].stock, 5000000)
        XCTAssertEqual(result.items[0].currency, "USD")
        XCTAssertEqual(result.items[0].title, "Apple Pencil")
        XCTAssertEqual(result.items[0].price, 165)
        XCTAssertEqual(result.items[0].discountedPrice, 160)
        XCTAssertEqual(result.items[0].registrationDate, 1620633347.3906322)
    }
    
    func test_상품_삭제_요청하기() {
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/item/77")
        else { XCTFail(); return }
        
        let promise = expectation(description: "Status code: 200")
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.httpBody = "{ \"password\": \"123\" }".data(using: .utf8)
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    
        URLSession.shared.dataTask(with: request) { (data, response, error) in
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
    
    func test_상품_등록_요청하기() {
        
        guard let url = URL(string: "https://camp-open-market-2.herokuapp.com/item") else {
            XCTFail(); return
        }
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        let boundary = "Boundary-\(UUID().uuidString)"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let params: [String: String] = [
            "title": "키오123123",
            "descriptions": "키오환불금지111111",
            "price": "12300000",
            "currency": "KRW",
            "stock": "254",
            "password": "1234"
        ]
        var body = Data()
        let boundaryPrefix = "--\(boundary)\r\n"
        
        for (key, value) in params {
            body.append(boundaryPrefix.data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        let imageKey = "images[]"
        let filename = "kio.gif"
        let mimeType = "image/gif"
        let imageURL = "/Users/steven/Desktop/test/kio.gif"
        let imageData = try? NSData(contentsOfFile: imageURL, options: []) as Data
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData!)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append(boundaryPrefix.data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(imageKey)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(imageData!)
        body.append("\r\n".data(using: .utf8)!)
        
        body.append("--".appending(boundary.appending("--")).data(using: .utf8)!)
        
        request.httpBody = body
        
        let promise = expectation(description: "post")
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else {
                XCTFail()
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                XCTAssertEqual(statusCode, 200)
                promise.fulfill()
            }
        }.resume()

        wait(for: [promise], timeout: 5)
    }
    
    func test_items_mock데이터_파싱하기() {
        let decoder = JSONDecoder()
        
        guard let dataAsset = NSDataAsset(name: "items") else {
            XCTFail()
            return
        }
        
        guard let result = try? decoder.decode(ProductList.self, from: dataAsset.data) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(result.items.count, 20)
        XCTAssertNil(result.items[0].discountedPrice)
        XCTAssertNil(result.items[0].images)
    }
    
    func test_item_mock데이터_파싱하기() {
        let decoder = JSONDecoder()
        
        guard let dataAsset = NSDataAsset(name: "item") else {
            XCTFail()
            return
        }
        
        guard let result = try? decoder.decode(Product.self, from: dataAsset.data) else {
            XCTFail()
            return
        }
        
        XCTAssertEqual(result.id, 1)
        XCTAssertEqual(result.title, "MacBook Pro")
    }
}
