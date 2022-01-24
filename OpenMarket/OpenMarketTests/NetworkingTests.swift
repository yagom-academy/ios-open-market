import XCTest

@testable import OpenMarket

class NetworkingTests: XCTestCase {
    
//    func test_1번페이지에_첫번째_상품의_id는_20이다() {
//        let data = NSDataAsset(name: "products")
//        let testSession = StubURLSession(alwaysSuccess: true, dummyData: data?.data)
//        let requester = ProductListAskRequester(pageNo: 1, itemsPerPage: 20)
//
//        testSession.request(requester: requester) {result in
//            switch result {
//            case .success(let data):
//                let products = requester.decode(data: data)
//                XCTAssertEqual(products?.pages[0].id, 20)
//            case .failure:
//                XCTAssertTrue(false)
//            }
//        }
//    }
    
    func test_post() {
        let semapore = DispatchSemaphore(value: 0)
        let data = UIImage(named: "image")
        let images = [data!]
        let params = ProductPost.Request.Params(name: "나무와숲재의사랑", descriptions: "빌어먹게신세졌습니다...", price: 1000.0, currency: .KRW, discountedPrice: nil, stock: nil, secret: "$4VptmhDPzSD3#zg")
        var requester = ProductPostRequester(params: params, images: images)
        var body = requester.createBody(productRegisterInformation: params, images: images, boundary: requester.boundary ?? "")
        requester.httpBody = body
        URLSession.shared.request(requester: requester) { result in
            switch result {
            case .success(let data):
                print("\(data)")
                print("성공")
                semapore.signal()
            case .failure(let error):
                print(error.localizedDescription)
                print("실패")
                semapore.signal()
            }
        }
        semapore.wait()
    }
}
