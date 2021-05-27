//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by sookim on 2021/05/11.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    
    var sut_urlProcess: URLProcess!
    var sut_getEssentialArticle: GetEssentialArticle!
    var sut_postCreateArticle: PostCreateArticle!
    var sut_patchUpdateArticle: PatchUpdateArticle!
    var sut_deleteArticle: DeleteArticle!

    
    override func setUpWithError() throws {
        super.setUp()
        
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        
        sut_urlProcess = URLProcess()
        sut_getEssentialArticle = GetEssentialArticle(urlProcess: URLProcess(), session: urlSession)
        sut_postCreateArticle = PostCreateArticle(manageMultipartForm: ManageMultipartForm(), urlProcess: URLProcess())
        sut_patchUpdateArticle = PatchUpdateArticle(manageMultipartForm: ManageMultipartForm(), urlProcess: URLProcess())
        sut_deleteArticle = DeleteArticle(urlProcess: URLProcess())
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        sut_urlProcess = nil
        sut_getEssentialArticle = nil
        sut_postCreateArticle = nil
        sut_patchUpdateArticle = nil
        sut_deleteArticle = nil
    }
  
    
    func convertDataToAssetImage(imageName: String) -> Data {
        let profileImage:UIImage = UIImage(named: imageName)!
        let imageData:Data = profileImage.pngData()!
        
        return imageData
    }
    
    func convertDataToURLImage(imageURL: String) -> Data {
        let url = URL(string: imageURL)
        let data = try? Data(contentsOf: url!)
        
        return data!
    }
    
    func extractAssetsData(_ item: String) -> NSDataAsset? {
        guard let itemData = NSDataAsset(name: item) else { return nil }
        
        return itemData
    }
    
    func test_AssetJSON데이터_추출() {
        XCTAssertNil(extractAssetsData("Itemss"))
        XCTAssertNotNil(extractAssetsData("Items"))
        XCTAssertNotNil(extractAssetsData("Item"))
    }
    
    func test_MockData디코딩() {
        guard let extractedItemsData = extractAssetsData("Items") else {
            XCTFail()
            return
        }
        guard let extractedItemData = extractAssetsData("Item")  else {
            XCTFail()
            return
        }

        XCTAssertEqual(sut_getEssentialArticle.decodeData(type: EntireArticle.self, data: extractedItemsData.data)?.page, 1)
        XCTAssertEqual(sut_getEssentialArticle.decodeData(type: EssentialArticle.self, data: extractedItemData.data)?.title, "MacBook Pro")
        XCTAssertEqual(sut_getEssentialArticle.decodeData(type: DetailArticle.self, data: extractedItemData.data)?.title, "MacBook Pro")
    }
    
    func test_추출된데이터확인() {
        let itemData = extractAssetsData("Item")
        
        guard let contents = sut_getEssentialArticle.decodeData(type: DetailArticle.self, data: itemData!.data) else { XCTFail(); return }
        
        XCTAssertEqual(contents.id, 1)
        XCTAssertEqual(contents.title, "MacBook Pro")
        XCTAssertEqual(contents.price, 1690000)
        XCTAssertEqual(contents.descriptions, """
Apple M1 칩은 13형 MacBook Pro에 믿을 수 없을 만큼의 속도와 파워를 선사합니다.
                    최대 2.8배 향상된 CPU 성능, 최대 5배 빨라진 그래픽 속도, 최대 11배 빨라진 머신 러닝 성능을 구현하는 최첨단 Apple 제작 Neural Engine, 여기에 무려 20시간 지속되는 Mac 사상 가장 오래가는 배터리까지.
                    외장은 Apple의 가장 사랑받는 프로용 노트북 그대로, 하지만 그 능력은 한 차원 더 높아졌습니다.
""")
        XCTAssertEqual(contents.currency, "KRW")
        XCTAssertEqual(contents.stock, 123)
        XCTAssertEqual(contents.images, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/images/1-2.png"
        ])
        XCTAssertEqual(contents.discountedPrice, 123)
        XCTAssertEqual(contents.thumbnails, [
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-.png",
            "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-.png"
        ])
        XCTAssertEqual(contents.registrationDate, 123.12)
    }
    
    func test_baseURL생성() {
        XCTAssertNotNil(sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/"))
        XCTAssertNotNil(sut_urlProcess.setBaseURL(urlString: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/aef0661e-ef05-426c-a9cf-a0ebf061ecbe/Items.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210518%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210518T064020Z&X-Amz-Expires=86400&X-Amz-Signature=e0fc4d4fe0ae89c9c4b9608f0194065d3e2a12766f1afce9db1ddc1574b751c4&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Items.json%22"))
        XCTAssertNotNil(sut_urlProcess.setBaseURL(urlString: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/a8c6f8d6-ad24-4cf9-8629-45bc6541771e/Item.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210518%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210518T064023Z&X-Amz-Expires=86400&X-Amz-Signature=f2866423786a6fe31485403b948108d1eef757584346daa428f88935393e32ff&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Item.json%22"))
    }
    
    func test_유저액션URL생성() {
        
        guard let baseURL = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        
        XCTAssertEqual(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticleList, index: "1"), URL(string: "items/1", relativeTo: baseURL))
        XCTAssertEqual(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticle, index: "1"), URL(string: "item/1", relativeTo: baseURL))
        XCTAssertEqual(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .addArticle), URL(string: "item", relativeTo: baseURL))
        XCTAssertEqual(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .updateArticle, index: "1"), URL(string: "item/1", relativeTo: baseURL))
        XCTAssertEqual(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .deleteArticle, index: "1"), URL(string: "item/1", relativeTo: baseURL))
    }
    
    func test_URLRequest생성() {
        guard let baseURL = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        
        XCTAssertNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticleList, index: "1")!, userAction: .viewArticleList ))
        XCTAssertNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticle, index: "1")!, userAction: .viewArticle ))
        XCTAssertNotNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .addArticle, index: "1")!, userAction: .addArticle ))
        XCTAssertNotNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .updateArticle, index: "1")!, userAction: .updateArticle ))
        XCTAssertNotNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .deleteArticle, index: "1")!, userAction: .deleteArticle ))
    }
    
    func test_GET메소드_상품조회() {
        let getExpt = expectation(description: "Waiting done harkWork...")
        guard let baseURL = sut_urlProcess.setBaseURL(urlString: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/aef0661e-ef05-426c-a9cf-a0ebf061ecbe/Items.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210519%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210519T082851Z&X-Amz-Expires=86400&X-Amz-Signature=5e5bf7060e0f3c9ae9b36ac43f3571744748231d95a16a1481db9eca65bdbb8f&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Items.json%22") else { return }
        
        guard let itemBaseURL = sut_urlProcess.setBaseURL(urlString: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/a8c6f8d6-ad24-4cf9-8629-45bc6541771e/Item.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210519%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210519T082830Z&X-Amz-Expires=86400&X-Amz-Signature=7721716c3b40ffa2b2bb3d17e3697497cdc832fb4b95fbb2de8f6bffca43dbaa&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Item.json%22") else { return }
        
        sut_getEssentialArticle.getParsing(url: itemBaseURL) { (testParam: Result<DetailArticle, Error>) in
            
            switch testParam {
            case .success(let post):
                XCTAssertEqual(post.title, "MacBook Pro")
                XCTAssertEqual(post.currency, "KRW")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }

        }
        
        sut_getEssentialArticle.getParsing(url: baseURL) { (testParam: Result<EntireArticle, Error>) in
            
            switch testParam {
            case .success(let post):
                XCTAssertEqual(post.page, 1)
                XCTAssertEqual(post.items.first?.title, "KRW")
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            getExpt.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_POST메소드_상품등록() {

        let expt = expectation(description: "Waiting done harkWork...")
        let boundary = "Boundary-\(UUID().uuidString)"
        let pngImage = convertDataToAssetImage(imageName: "github")
        guard let baseUrl = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .addArticle) else { return }
        let createArticle = CreateArticle(title: "도지", descriptions: "일론머스크", price: 100000, currency: "KRW", stock: 10000, discountedPrice: 222, images: [pngImage], password: "1234")
        let postRequest = sut_urlProcess.setURLRequest(url: httpURL, userAction: .addArticle, boundary: boundary)
        let data = sut_postCreateArticle.makeRequestBody(formdat: createArticle, boundary: boundary, imageData: pngImage)
        
        sut_postCreateArticle.postData(urlRequest: postRequest, requestBody: data) { (isSuccess) in
            XCTAssertTrue(isSuccess)
            expt.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test_PATCH메소드_상품수정() {
        let expt = expectation(description: "Waiting done harkWork...")
        let boundary = "Boundary-\(UUID().uuidString)"
        let pngImage = convertDataToAssetImage(imageName: "github")
        guard let baseUrl = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .updateArticle, index: "197") else { return }
        let updateArticle = UpdateArticle(title: "폴리", descriptions: "매쓰", price: 30000, currency: "KRW", stock: 3000000, discountedPrice: 0, images: [pngImage], password: "1234")
        let updateRequest = sut_urlProcess.setURLRequest(url: httpURL, userAction: .updateArticle, boundary: boundary)
        let data = sut_patchUpdateArticle.updateRequestBody(formdat: updateArticle, boundary: boundary, imageData: pngImage)
        
        sut_patchUpdateArticle.patchData(urlRequest: updateRequest, requestBody: data) { (isSuccess) in
            XCTAssertTrue(isSuccess)
            expt.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    

    func test_DELETE메소드_상품삭제() {
        let expt = expectation(description: "Waiting done harkWork...")
        guard let baseUrl = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .deleteArticle, index: "193") else { return }
        let deleteRequest = sut_urlProcess.setURLRequest(url: httpURL, userAction: .deleteArticle)
        let data = sut_deleteArticle.encodePassword(urlRequest: deleteRequest, password: "1234")
        
        sut_deleteArticle.deleteData(urlRequest: deleteRequest, data: data) { (isSuccess) in
            XCTAssertTrue(isSuccess)
            expt.fulfill()
        }
        waitForExpectations(timeout: 5.0, handler: nil)
    }

    func test_서버통신하지않는응답성공() {
        let expt = expectation(description: "Waiting done harkWork...")
        guard let assetData = NSDataAsset(name: "Item") else { return }
        
        guard let baseUrl = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .viewArticle, index: "1") else { return }
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: httpURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, assetData.data)
        }
        
        sut_getEssentialArticle.getParsing(url: httpURL) { (result: Result<DetailArticle, Error>) in
            switch result {
            case .success(let post):
                XCTAssertEqual(post.id, 1)
                XCTAssertEqual(post.title, "MacBook Pro")
                XCTAssertEqual(post.currency, "KRW")
            case .failure(let error):
                XCTFail("Error was not expected: \(error.localizedDescription)")
            }
            expt.fulfill()
        }
        wait(for: [expt], timeout: 1.0)
    }
    
    
}
