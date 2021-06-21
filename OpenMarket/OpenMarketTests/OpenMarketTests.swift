//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by kio on 2021/05/31.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    let session: MockURLSessionProtocol
    init(session: URLSession = .shared) {
        self.session = session
        super.init()
    }
    
    func getData(completion: @escaping (Result<ItemDetail, Error>) -> Void) {
        
        let request = URLRequest(url: Network.firstPage.url)
        
        let task: URLSessionDataTask = session
            .dataTask(with: request) { data, urlResponse, error in
                guard let response = urlResponse as? HTTPURLResponse,
                      (200...399).contains(response.statusCode) else {
                    completion(.failure(error ?? APIError.unknownError))
                    return
                }
                
                if let data = data {
                    guard let decodingData = try? JSONDecoder().decode(ItemDetail.self, from: data) else {
                        completion(.failure(APIError.unknownError))
                        return
                    }
                    completion(.success(decodingData))
                }
            }
        task.resume()
    }
    
    
    func test_getData_AssetData() {
        let expectation = XCTestExpectation()
        let response = try? JSONDecoder().decode(ItemDetail.self,
                                                 from: NSDataAsset(name: "Items")!.data)
         
        getData { result in
            switch result {
            case .success:
                XCTAssertEqual("MacBook Pro", response?.title)
            case .failure:
                XCTFail()
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
}

