//
//  RequestBodyTests.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2021/05/18.
//

import XCTest
@testable import OpenMarket

class RequestBodyTests: XCTestCase {
    var sut: RequestBodyEncoder!
    var dummyImageData: Data!
    var dummyMultipartFormData: Data!
    var dummyJSONData: Data!
    var dummyFormDataModel: PatchingItem!
    var dummyJSONDataModel: DeletingItem!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RequestBodyEncoder()
        dummyImageData = UIImage(systemName: "pencil")!.jpegData(compressionQuality: 0.1)!
        dummyMultipartFormData = """
                --\(RequestBodyEncoder.boundary)\r\nContent-Disposition: form-data; name=\"title\"\r\n\r\n야곰 아카데미\r\n--\(RequestBodyEncoder.boundary)\r\nContent-Disposition: form-data; name=\"descriptions\"\r\n\r\n이유있는 코드가 시작되는 곳, 야곰 아카데미입니다. 개발자 커리어를 시작하기 위한 부트캠프를 운영하고 있습니다.\r\n--\(RequestBodyEncoder.boundary)\r\nContent-Disposition: form-data; name=\"price\"\r\n\r\n10000000000\r\n--\(RequestBodyEncoder.boundary)\r\nContent-Disposition: form-data; name=\"stock\"\r\n\r\n1\r\n--\(RequestBodyEncoder.boundary)\r\nContent-Disposition: form-data; name=\"password\"\r\n\r\n1q2w3e4r\r\n--\(RequestBodyEncoder.boundary)--
                """.data(using: .utf8)!
        dummyJSONData = "{\"password\":\"1q2w3e4r\"}".data(using: .utf8)!
        dummyFormDataModel = PatchingItem(title: "야곰 아카데미", descriptions: "이유있는 코드가 시작되는 곳, 야곰 아카데미입니다. 개발자 커리어를 시작하기 위한 부트캠프를 운영하고 있습니다.", price: 10000000000, currency: nil, stock: 1, discountedPrice: nil, images: [], password: "1q2w3e4r")
        dummyJSONDataModel = DeletingItem(password: "1q2w3e4r")
    }

    override func tearDownWithError() throws {
        sut = nil
        dummyImageData = nil
        dummyMultipartFormData = nil
        dummyJSONData = nil
        dummyFormDataModel = nil
        dummyJSONDataModel = nil
    }

    func test_formData_type을_multipartFormData로_변환할_수_있다() {
        let encodedData: Data = try! sut.encode(dummyFormDataModel)

        XCTAssertEqual(String(decoding: encodedData, as: UTF8.self),
                       String(decoding: dummyMultipartFormData, as: UTF8.self))
    }

    func test_jsonData_type을_json_형식의_data로_변환할_수_있다() {
        let encodedData: Data = try! sut.encode(dummyJSONDataModel)

        XCTAssertEqual(String(decoding: encodedData, as: UTF8.self),
                       String(decoding: dummyJSONData, as: UTF8.self))
    }
}
