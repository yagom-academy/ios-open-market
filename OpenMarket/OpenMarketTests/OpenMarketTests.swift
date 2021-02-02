//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Yeon on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    private var itemList: ItemList?
    private var item: Item?
    private var deleteItem: ItemToDelete?
    
    func testMakeURL() {
        if let getItemListURL = ItemManager.shared.makeURL(method: .get, path: .items, param: 1) {
            XCTAssertEqual(getItemListURL, URL(string: "https://camp-open-market.herokuapp.com/items/1"))
        }
        if let getItemDetailURL = ItemManager.shared.makeURL(method: .get, path: .item, param: 1) {
            XCTAssertEqual(getItemDetailURL, URL(string: "https://camp-open-market.herokuapp.com/item/1"))
        }
        if let postItemURL = ItemManager.shared.makeURL(method: .post, path: .item, param: nil) {
            XCTAssertEqual(postItemURL, URL(string: "https://camp-open-market.herokuapp.com/item"))
        }
        if let patchItemURL = ItemManager.shared.makeURL(method: .patch, path: .item, param: 1) {
            XCTAssertEqual(patchItemURL, URL(string: "https://camp-open-market.herokuapp.com/item/1"))
        }
        if let deleteItemURL = ItemManager.shared.makeURL(method: .delete, path: .item, param: 1) {
            XCTAssertEqual(deleteItemURL, URL(string: "https://camp-open-market.herokuapp.com/item/1"))
        }
    }
    
    func testMakeURLRequest() {
        // GET URLReqeust 테스트
        guard let getItemDetailURL = ItemManager.shared.makeURL(method: .get, path: .item, param: 1) else {
            return
        }
        guard let getRequest = ItemManager.shared.makeURLRequestWithoutRequestBody(method: .get, requestURL: getItemDetailURL) else {
            return
        }
        XCTAssertEqual(getItemDetailURL, URL(string: "https://camp-open-market.herokuapp.com/item/1"))
        XCTAssertEqual(getRequest.httpMethod, "GET")
        
        // PATCH URLRequest 테스트
        guard let patchItemURL = ItemManager.shared.makeURL(method: .patch, path: .item, param: 66) else {
            return
        }
        let patchItem = ItemToUpload(title: nil,
                                     descriptions: nil,
                                     price: 750000,
                                     currency: nil,
                                     stock: 500000,
                                     discountedPrice: nil,
                                     images: nil,
                                     password: "asdfqwerzxcv")
        guard let jsonData = try? JSONEncoder().encode(patchItem as? ItemToUpload) else {
            return
        }
        guard let patchRequest = ItemManager.shared.makeURLRequestWithRequestBody(method: .patch, requestURL: patchItemURL, item: patchItem) else {
            return
        }
        XCTAssertEqual(patchItemURL, URL(string: "https://camp-open-market.herokuapp.com/item/66"))
        XCTAssertEqual(patchRequest.httpMethod, "PATCH")
        XCTAssertEqual(patchRequest.httpBody, jsonData)
    }
    
    func testGetItemListAsync() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        
        ItemManager.shared.loadData(method: .get, path: .items, param: 1) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    itemList = try JSONDecoder().decode(ItemList.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        let page = itemList?.page
        
        XCTAssertEqual(page, 1)
    }
    
    func testGetItemDetail() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        ItemManager.shared.loadData(method: .get, path: .item, param: 1) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        let id = item?.id
        let title = item?.title
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(id, 1)
        XCTAssertEqual(title, "MacBook Air")
        XCTAssertEqual(price, 1290000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 1000000000)
    }
    
    func testPostItem() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        guard let airPodMaxImage1 = UIImage(named: "AirPodMax1"), let airPodMaxImage2 = UIImage(named: "AirPodMax2") else {
            return
        }
        var imageDataStringArray: [String] = []
        guard let airPodMaxImageData1 = UIImageToData(image: airPodMaxImage1), let airPodMaxImageData2 = UIImageToData(image: airPodMaxImage2) else {
            return
        }
        imageDataStringArray.append(airPodMaxImageData1)
        imageDataStringArray.append(airPodMaxImageData2)
        
        let newItem = ItemToUpload(title: "AirPod Max",
                                   descriptions: "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ",
                                   price: 700000,
                                   currency: "KRW",
                                   stock: 10000,
                                   discountedPrice: nil,
                                   images: imageDataStringArray,
                                   password: "asdfqwerzxcv")
        
        ItemManager.shared.uploadData(method: .post, path: .item, item: newItem, param: nil) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let title = item?.title
        let description = item?.descriptions
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(title, "AirPod Max")
        XCTAssertEqual(description, "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ")
        XCTAssertEqual(price, 700000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 10000)
    }
    
    func testPatchItem() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        let param: UInt = 392
        let patchItem = ItemToUpload(title: nil,
                                     descriptions: nil,
                                     price: 750000,
                                     currency: nil,
                                     stock: 500000,
                                     discountedPrice: nil,
                                     images: nil,
                                     password: "asdfqwerzxcv")
        
        ItemManager.shared.uploadData(method: .patch, path: .item, item: patchItem, param: param) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let id = item?.id
        let title = item?.title
        let description = item?.descriptions
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(id, param)
        XCTAssertEqual(title, "AirPod Max")
        XCTAssertEqual(description, "귀를 호강시켜주는 에어팟 맥스! 사주실 분 구해요ㅠ")
        XCTAssertEqual(price, 750000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 500000)
    }
    
    private func UIImageToData(image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 0.8)?.base64EncodedData() else {
            return nil
        }
        let dataString = String(decoding: data, as: UTF8.self)
        return dataString
    }
    
    func testDeleteData() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        let param: UInt = 394
        let item = ItemToDelete(id: param, password: "asdfqwerzxcv")
        
        ItemManager.shared.deleteData(method: .delete, path: .item, item: item, param: param) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    deleteItem = try JSONDecoder().decode(ItemToDelete.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 10.0)
        let id = deleteItem?.id
        
        XCTAssertEqual(id, param)
    }
    
    var itemManagerWithoutNetwork: ItemManagerWithoutNetwork!
    let session = MockURLSession()
    
    override func setUp() {
        super.setUp()
        itemManagerWithoutNetwork = ItemManagerWithoutNetwork(session: session)
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testLoadResumeCalledWithoutNetwork() {
        let dataTask = MockURLSessionDataTask()
        session.nextDataTask = dataTask
        
        itemManagerWithoutNetwork.loadData(method: .get, path: .items, param: 1) { result in
            // Return data
        }
        XCTAssert(dataTask.resumeWasCalled)
    }
    
    func testLoadReturnDataWithoutNetwork() {
        guard let mockDataURL = Bundle.main.url(forResource: "Item", withExtension: "json") else {
            return
        }
        let expectedData = try? Data(contentsOf: mockDataURL)
        session.nextData = expectedData
        
        var actualData: Data?
        itemManagerWithoutNetwork.loadData(method: .get, path: .item, param: 1) { result in
            switch result {
            case .success(let data):
                actualData = data
            case .failure(let error):
                print(error)
            }
        }
        XCTAssertNotNil(actualData)
    }
}

//MARK: Protocol for MOCK/Real
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

//MARK: MOCK
class MockURLSession: URLSessionProtocol {
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    private (set) var lastURL: URL?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
}

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private (set) var resumeWasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
}

//MARK: ItemManagerWithoutNetwork Implemenation
struct ItemManagerWithoutNetwork {
    typealias resultHandler = (Result<Data?, OpenMarketError>) -> Void
    private let session: URLSessionProtocol
    init(session: URLSessionProtocol) {
        self.session = session
    }
    
    func loadData(method: HttpMethod, path: PathOfURL, param: UInt, completion: @escaping resultHandler) {
        guard let requestUrl = makeURL(method: method, path: path, param: param) else {
            return completion(.failure(.failSetUpURL))
        }
        
        guard let request = makeURLRequestWithoutRequestBody(method: method, requestURL: requestUrl) else {
            return completion(.failure(.failMakeURLRequest))
        }
        
        communicateToServerWithDataTask(with: request, completion: completion)
    }
    
    private func makeURL(method: HttpMethod, path: PathOfURL, param: UInt? = nil) -> URL? {
        var url: URL?
        url = NetworkConfig.setUpUrl(method: method, path: path, param: param)
        return url
    }
    
    private func makeURLRequestWithoutRequestBody(method: HttpMethod, requestURL: URL) -> URLRequest? {
        var request = URLRequest(url: requestURL)
        request.httpMethod = method.rawValue
        return request
    }
    
    private func communicateToServerWithDataTask(with request: URLRequest, completion: @escaping resultHandler) {
        let dataTask = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if let error = error {
                return completion(.failure(.failTransportData))
            }
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                return completion(.failure(.failDeleteData))
            }
            
            guard let data = data else {
                return completion(.failure(.failGetData))
            }
            return completion(.success(data))
        }
        dataTask.resume()
    }
}
