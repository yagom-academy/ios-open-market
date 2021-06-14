//
//  URLSessionManagerTests.swift
//  OpenMarketTest
//
//  Created by 김찬우 on 2021/06/01.
//

import XCTest
@testable import OpenMarket

class URLSessionManagerTests: XCTestCase {
    func test_getServerData메서드에서_서버에요청을보냈을때_convertedData에_원하는데이터가_저장되는가(){
        let expectation = XCTestExpectation()
        let clientRequest = GETRequest(page: 1, id: 1, descriptionAboutMenu: .목록조회)
        let networkManager = NetworkManager<Items>(clientRequest: clientRequest, session: URLSession.shared)

        networkManager.getServerData(url: clientRequest.urlRequest.url!){ result in
            switch result {
            case .failure: XCTFail()
            case .success(let data):
                XCTAssertEqual(data.page, 1)
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 3)
    }

    func test_getRequest인스턴스를만들었을때_원하는형태의_URL이생성되는가() {
        let getRequest = GETRequest(page: 1, id: 1, descriptionAboutMenu: .목록조회)
        XCTAssertEqual(getRequest.urlRequest.url, URL(string: "https://camp-open-market-2.herokuapp.com/items/1"))
    }

    func test_네트워크와무관하게_원하는response전달시_원하는결과가도출되는가() {
        let expectation = XCTestExpectation()
        let clientRequest = GETRequest(page: 1, id: 1, descriptionAboutMenu: .상품조회)
        let networkManager = NetworkManager<Item>(clientRequest: clientRequest, session: MockURLSession(caseOfResponse: .rightCase))
        networkManager.getServerData(url: clientRequest.urlRequest.url!){ result in
            switch result {
            case .failure: XCTFail()
            case .success(let data):
                XCTAssertEqual(data.id, 1)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
}
