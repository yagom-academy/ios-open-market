//
//  DataFetchTests.swift
//  DataFetchTests
//
//  Created by 웡빙, 보리사랑 on 2022/07/11.
//
import XCTest

class DataFetchTests: XCTestCase {
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }

    func test_mock데이터에대해서_decode의결과가_리턴이_nil이아님을테스트() throws {
        //given
        guard let filePath = NSDataAsset.init(name: "MockData") else {
            XCTAssertNotNil(nil)
            return
        }
        //when
        guard let result = decode(from: filePath.data, to: ProductPage.self) else {
            XCTAssertNotNil(nil)
            return
        }
        //then
        XCTAssertNotNil(result)
    }
    func test_타입이다른mock데이터에대해서_decode의결과가_리턴이_nil인지테스트() throws {
        //given
        guard let filePath = NSDataAsset.init(name: "DiffTypeMockData") else {
            XCTAssertNotNil(nil)
            return
        }
        //when
        guard let result = decode(from: filePath.data, to: ProductPage.self) else {
            XCTAssertNil(nil)
            return
        }
        //then
        XCTAssertNotNil(result)
    }
    func test_잘못된키를가진mock데이터에대해서_decode의결과가_리턴이_nil인지테스트() throws {
        //given
        guard let filePath = NSDataAsset.init(name: "WrongKeyMockData") else {
            XCTAssertNotNil(nil)
            return
        }
        //when
        guard let result = decode(from: filePath.data, to: ProductPage.self) else {
            XCTAssertNil(nil)
            return
        }
        //then
        XCTAssertNotNil(result)
    }
    func test_Value의타입이다른mock데이터에대해서_decode의결과가_리턴이_nil인지테스트() throws {
        //given
        guard let filePath = NSDataAsset.init(name: "WrongValueTypeMockData") else {
            XCTAssertNotNil(nil)
            return
        }
        //when
        guard let result = decode(from: filePath.data, to: ProductPage.self) else {
            XCTAssertNil(nil)
            return
        }
        //then
        XCTAssertNotNil(result)
    }
    func test_데이터가손상된mock데이터에대해서_decode의결과가_리턴이_nil인지테스트() throws {
        //given
        guard let filePath = NSDataAsset.init(name: "CorruptedMockData") else {
            XCTAssertNotNil(nil)
            return
        }
        //when
        guard let result = decode(from: filePath.data, to: ProductPage.self) else {
            XCTAssertNil(nil)
            return
        }
        //then
        XCTAssertNotNil(result)
    }
}
