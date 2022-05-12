//
//  NetworkHandlerTest.swift
//  NetworkHandlerTest
//
//  Created by 두기, minseong on 2022/05/11.
//

import XCTest
@testable import OpenMarket

class NetworkHandlerTest: XCTestCase {
    var sut: NetworkHandler!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = NetworkHandler()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func convertJsonToData(fileName: String) -> Data {
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: fileName, ofType: "json")
        let jsonString = try? String(contentsOfFile: path ?? "")
        return jsonString?.data(using: .utf8) ?? Data()
    }
    
}
