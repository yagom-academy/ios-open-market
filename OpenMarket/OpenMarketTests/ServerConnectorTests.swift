//
//  ServerConnectorTests.swift
//  OpenMarketTests
//
//  Created by 김찬우 on 2021/05/21.
//

import XCTest
@testable import OpenMarket

enum NetworkError: Error {
    case notStartedError
    case notDecodedError
    case anonymousError
}

class ServerConnectorTests: XCTestCase {
    func test_getServerData메서드를실행해_원하는객체를_생성할수있는가() {
        let expectation = XCTestExpectation(description: "좀 기다려봐~~~~~~~")
        
        func 비동기처리함수(completionHandler: @escaping (Result<Items, NetworkError>) -> Void) {
            URLSession.shared.dataTask(with: URL(string: "https://camp-open-market-2.herokuapp.com/items/1")!) { data, response, error in
                if let data = data {
                    guard let decodedData = try? JSONDecoder().decode(Items.self, from: data) else {
                        completionHandler(.failure(.notDecodedError))
                        return
                    }
                    completionHandler(.success(decodedData))
                } else {
                    completionHandler(.failure(.anonymousError))
                }
            }.resume()
        }

        비동기처리함수 { result in
            switch result {
            case .failure(let error):
                XCTFail("\(error)")
            case .success(let items):
                XCTAssertEqual(items.page, 1)
            }
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 5)
    }
}
