//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by JeongTaek Han on 2022/01/03.
//

import XCTest

class OpenMarketTests: XCTestCase {
    
    var sutURLSessionProvider: URLSessionProvider!
    
    override func setUpWithError() throws {
        
        
    }

    override func tearDownWithError() throws {
        sutURLSessionProvider = nil
    }
    
    private func setUpProvider(data: Data?, urlString: String, statusCode: Int) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let response = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
        let dummy = DummyData(data: data, response: response, error: nil)
        let urlSession = StubURLSession(dummy: dummy)
        
        sutURLSessionProvider = URLSessionProvider(
            session: urlSession,
            baseURL: urlString
        )
    }
    private func decode(data: Data) throws -> Page {
        let decoder = JSONDecoder()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
        return try decoder.decode(Page.self, from: data)
    }

    func test_URLSessionProvider에_request요청시_productsJSON을정상적으로반환하는가() throws {
        //given
        setUpProvider(data: NSDataAsset(name: "products")?.data, urlString: "https://market-training.yagom-academy.kr/", statusCode: 200)
        
        //when
        guard let url = URL(string: "https://market-training.yagom-academy.kr/") else {
            return
        }
        //then
        sutURLSessionProvider.request(URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decode(data: data)
                    print(result)
                    XCTAssertNotNil(result)
                } catch {
                    XCTFail("error")
                }
            case .failure(let error):
                XCTFail("error")
            }
        }
    }
    
    func test_URLSessionProvider에_request요청시_404코드가응답되었을때_error를정상적으로반환하는가() throws {
        //given
        setUpProvider(data: NSDataAsset(name: "products")?.data, urlString: "https://market-training.yagom-academy.kr/", statusCode: 404)
        
        //when
        guard let url = URL(string: "https://market-training.yagom-academy.kr/") else {
            return
        }
        //then
        sutURLSessionProvider.request(URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                do {
                    let result = try self.decode(data: data)
                    print(result)
                    XCTFail()
                } catch {
                    XCTFail("error")
                }
            case .failure(let error):
                XCTAssertEqual(URLSessionProviderError.statusError, error)
            }
        }
    }
}
