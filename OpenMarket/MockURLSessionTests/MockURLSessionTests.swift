//
//  OpenMarket - MockURLSessionTests.swift
//  Created by Zhilly, Dragon. 22/11/16
//  Copyright © yagom. All rights reserved.
//

import XCTest
@testable import OpenMarket

class MockURLSessionTests: XCTestCase {
    let mockSession: MockURLSession = MockURLSession()
    var sut: NetworkManager!
    
    override func setUpWithError() throws {
        sut = .init(session: mockSession)
    }
    
    func test_data가Json형태로주어졌을때_getItemList에서data를가져오는것을성공하면_data와결과가같은지() {
        // given
        let jsonDecoder: JSONDecoder = JSONDecoder()
        
        jsonDecoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
          let container = try decoder.singleValueContainer()
          let dateStr = try container.decode(String.self)
          
          let formatter = DateFormatter()
          formatter.calendar = Calendar(identifier: .iso8601)
          formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
          
          if let date = formatter.date(from: dateStr) {
            return date
          }
            throw JSONDecodeError.invalidData
        })
        
        let mockData = try? jsonDecoder.decode(ProductList.self, from: MockData.data)
        
        // when
        sut.request(from: URLManager.productList(pageNumber: 1, itemsPerPage: 100).url, httpMethod: HttpMethodEnum.get) { result in
            switch result {
            case .success(let data):
                guard let test = JSONDecoder.decodeData(data: data, to: ProductList.self) else {
                    XCTFail("Decode Error")
                    return
                }
                print(test)
                // then
                XCTAssertEqual(mockData?.pageNumber, test.pageNumber)
                XCTAssertEqual(mockData?.totalCount, test.totalCount)
            case .failure(_):
                XCTFail("getItemList failure")
                return
            }
        }
    }
    
    func test_MockURLSession에서실패하도록설정했을때_getItemList를실행하면_fail이뜨고error가clientError와_같은지() {
        // given
        sut = NetworkManager(session: MockURLSession(isRequestSuccess: false))

        // when
        sut.request(from: URLManager.productList(pageNumber: 1, itemsPerPage: 100).url, httpMethod: HttpMethodEnum.get) { result in
            switch result {
            case .success(_):
                XCTFail("result is success")
            case .failure(let error):
                // then
                XCTAssertEqual(error, NetworkError.clientError)
            }
        }
    }
}
