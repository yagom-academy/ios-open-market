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
        sut_urlProcess = URLProcess()
        sut_getEssentialArticle = GetEssentialArticle()
        sut_postCreateArticle = PostCreateArticle()
        sut_patchUpdateArticle = PatchUpdateArticle()
        sut_deleteArticle = DeleteArticle()
    }
    
    override func tearDownWithError() throws {
        super.tearDown()
        sut_urlProcess = nil
        sut_getEssentialArticle = nil
        sut_postCreateArticle = nil
        sut_patchUpdateArticle = nil
        sut_deleteArticle = nil
    }
    
    func extractData(_ item: String) -> NSDataAsset? {
        guard let itemData = NSDataAsset(name: item) else {
            return nil
        }
        return itemData
    }
    
    func decodeExtractedData<T: Decodable>(_ object: T.Type, of data: Data) -> T? {
        let decoder = JSONDecoder()
        
        do {
            let contents = try decoder.decode(object, from: data)
            return contents
        } catch {
            return nil
        }
    }
    
    func test_Mock_Item데이터추출() {
        XCTAssertNil(extractData("Itemss"))
    }
    
    func test_Mock_Items데이터추출() {
        XCTAssertNil(extractData("Items"))
    }
    
    func test_Mock_Items디코딩() {
        let extractedData = extractData("Items")
        XCTAssertNil(decodeExtractedData(EntireArticle.self, of: extractedData!.data))
    }
    
    func test_Mock_Item디코딩_withEsstialArticle() {
        let extractedData = extractData("Item")
        XCTAssertNil(decodeExtractedData(EssentialArticle.self, of: extractedData!.data))
    }
    
    func test_Mock_Item디코딩_withDetailArticle() {
        let extractedData = extractData("Item")
        XCTAssertNil(decodeExtractedData(DetailArticle.self, of: extractedData!.data))
    }
    
    func test_추출된데이터확인() {
        let itemData = extractData("Item")
        
        guard let contents = decodeExtractedData(DetailArticle.self, of: itemData!.data) else { XCTFail(); return }
        XCTAssertEqual(contents.id, 1)
        XCTAssertEqual(contents.title, "abc")
        XCTAssertEqual(contents.price, 123)
        XCTAssertEqual(contents.descriptions, "abc")
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
        
        XCTAssertNotNil(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticleList, index: "1"))
        XCTAssertNotNil(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticle, index: "1"))
        XCTAssertNotNil(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .addArticle, index: "1"))
        XCTAssertNotNil(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .updateArticle, index: "1"))
        XCTAssertNotNil(sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .deleteArticle, index: "1"))
        
    }
    
    func test_URLRequest생성() {
        guard let baseURL = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        
        XCTAssertNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticleList, index: "1")!, userAction: .viewArticleList ))
        XCTAssertNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .viewArticle, index: "1")!, userAction: .viewArticle ))
        XCTAssertNotNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .addArticle, index: "1")!, userAction: .addArticle ))
        XCTAssertNotNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .updateArticle, index: "1")!, userAction: .updateArticle ))
        XCTAssertNotNil(sut_urlProcess.setURLRequest(url: sut_urlProcess.setUserActionURL(baseURL: baseURL, userAction: .deleteArticle, index: "1")!, userAction: .deleteArticle ))
    }
    
    func test_decodeData() {
        let extractedData = extractData("Item")
        XCTAssertNil(sut_getEssentialArticle.decodeData(type: DetailArticle.self, data: extractedData!.data))
    }
    
    func test_GET메소드_상품조회() {
        let expt = expectation(description: "Waiting done harkWork...")
        guard let baseURL = sut_urlProcess.setBaseURL(urlString: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/aef0661e-ef05-426c-a9cf-a0ebf061ecbe/Items.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210518%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210518T064020Z&X-Amz-Expires=86400&X-Amz-Signature=e0fc4d4fe0ae89c9c4b9608f0194065d3e2a12766f1afce9db1ddc1574b751c4&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Items.json%22") else { return }
        
        guard let itemBaseURL = sut_urlProcess.setBaseURL(urlString: "https://s3.us-west-2.amazonaws.com/secure.notion-static.com/a8c6f8d6-ad24-4cf9-8629-45bc6541771e/Item.json?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAT73L2G45O3KS52Y5%2F20210518%2Fus-west-2%2Fs3%2Faws4_request&X-Amz-Date=20210518T064023Z&X-Amz-Expires=86400&X-Amz-Signature=f2866423786a6fe31485403b948108d1eef757584346daa428f88935393e32ff&X-Amz-SignedHeaders=host&response-content-disposition=filename%20%3D%22Item.json%22") else { return }
        
        
        
        sut_getEssentialArticle.getParsing(url: itemBaseURL) { (testParam: DetailArticle) in
            XCTAssertEqual(testParam.title, "rr")
            XCTAssertEqual(testParam.currency, "궁")
        }
        
        sut_getEssentialArticle.getParsing(url: baseURL) { (testParam: EntireArticle) in
            XCTAssertEqual(testParam.page, 54)
            XCTAssertEqual(testParam.items.first?.title, "궁")

            expt.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    
    func test_POST메소드_상품등록() {

        let expt = expectation(description: "Waiting done harkWork...")
        let boundary = "Boundary-\(UUID().uuidString)"
        let pngImage = convertDataToAssetImage(imageName: "github")
        guard let baseUrl = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .addArticle) else { return }
        
        let createArticle = CreateArticle(title: "귀감", descriptions: "싸구려", price: 15326, currency: "KRW", stock: 15, discountedPrice: 222, images: [pngImage], password: "1234")

        let postRequest = sut_urlProcess.setURLRequest(url: httpURL, userAction: .addArticle, boundary: boundary)
        let data = sut_postCreateArticle.makeRequestBody(formdat: createArticle, boundary: boundary, imageData: pngImage)
        sut_postCreateArticle.postData(urlRequest: postRequest, requestBody: data)
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .viewArticleList, index: "6") else { return }
        
        
        sut_getEssentialArticle.getParsing(url: httpURL) { (testParam: EntireArticle) in
            
            for i in 1..<testParam.items.count
            {
                XCTAssertEqual(testParam.items[i].title, "궁")
            }
            XCTAssertEqual(testParam.page, 54)
            
            expt.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
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
    
    func test_PATCH메소드_상품수정() {
        let expt = expectation(description: "Waiting done harkWork...")
        let boundary = "Boundary-\(UUID().uuidString)"
        let pngImage = convertDataToAssetImage(imageName: "github")
        guard let baseUrl = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .updateArticle, index: "188") else { return }
        
        let updateArticle = UpdateArticle(title: "감자파니다", descriptions: "싸구려", price: 15326, currency: "KRW", stock: 15, discountedPrice: 222, images: [pngImage], password: "1234")

        let updateRequest = sut_urlProcess.setURLRequest(url: httpURL, userAction: .updateArticle, boundary: boundary)
        let data = sut_patchUpdateArticle.updateRequestBody(formdat: updateArticle, boundary: boundary, imageData: pngImage)
        sut_patchUpdateArticle.patchData(urlRequest: updateRequest, requestBody: data)
        sut_getEssentialArticle.getParsing(url: httpURL) { (testParam: EntireArticle) in
            
            for i in 1..<testParam.items.count
            {
                XCTAssertEqual(testParam.items[i].title, "궁")
            }
            XCTAssertEqual(testParam.page, 54)
            
            expt.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }
    

    func test_DELETE메소드_상품삭제() {
        let expt = expectation(description: "Waiting done harkWork...")
        guard let baseUrl = sut_urlProcess.setBaseURL(urlString: "https://camp-open-market-2.herokuapp.com/") else { return }
        guard let httpURL = sut_urlProcess.setUserActionURL(baseURL: baseUrl, userAction: .deleteArticle, index: "188") else { return }
        let deleteRequest = sut_urlProcess.setURLRequest(url: httpURL, userAction: .deleteArticle)
        let data = sut_deleteArticle.encodePassword(urlRequest: deleteRequest, password: "1234")
        sut_deleteArticle.deleteData(urlRequest: deleteRequest, data: data)
        
        sut_getEssentialArticle.getParsing(url: httpURL) { (testParam: EntireArticle) in
            
            for i in 1..<testParam.items.count
            {
                XCTAssertEqual(testParam.items[i].title, "궁")
            }
            XCTAssertEqual(testParam.page, 54)
            
            expt.fulfill()
        }
        
        waitForExpectations(timeout: 5.0, handler: nil)
    }

}
