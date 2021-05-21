//
//  APIModelTests.swift
//  OpenMarketTests
//
//  Created by duckbok on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class APIModelTests: XCTestCase {
    var dummyPostingItem: PostingItem!
    var dummyPatchingItem: PatchingItem!
    
    override func setUpWithError() throws {
        dummyPostingItem = PostingItem(title: "끔찍한 디버깅",
                                       descriptions: "끔찍한 디버깅입니다.",
                                       price: 1000,
                                       currency: "KRW",
                                       stock: 10,
                                       discountedPrice: nil,
                                       images: [UIImage(systemName: "zzz")!.jpegData(compressionQuality: 1)!],
                                       password: "1234")
        
        dummyPatchingItem = PatchingItem(title: "귀여운 바나나",
                                         descriptions: "귀여운 바나나입니다.",
                                         price: 1000,
                                         currency: nil,
                                         stock: nil,
                                         discountedPrice: nil,
                                         images: [UIImage(systemName: "zzz")!.jpegData(compressionQuality: 1)!],
                                         password: "1234")
    }
    
    func test_PostingItem의_textFields() {
        let sut = dummyPostingItem.textFields
        let expectedResult: [(key:String, value: String)] = [
            ("title", "끔찍한 디버깅"),
        ("descriptions", "끔찍한 디버깅입니다."),
            ("price", "1000"),
        ("currency", "KRW"),
            ("stock", "10"),
            ("password", "1234")
        ]
        
        for i in 0..<sut.count {
            XCTAssertEqual(sut[i].key, expectedResult[i].key)
            XCTAssertEqual(sut[i].value, expectedResult[i].value)
        }
    }
    
    func test_PostingItem의_fileFields() {
        let sut = dummyPostingItem.fileFields
        let jpegData = UIImage(systemName: "zzz")!.jpegData(compressionQuality: 1)!
        let expectedResult: [(key:String, value: Data)] = [
            ("images[]", jpegData)
        ]
        
        for i in 0..<sut.count {
            XCTAssertEqual(sut[i].key, expectedResult[i].key)
            XCTAssertEqual(sut[i].value, expectedResult[i].value)
        }
    }
    
    func test_PacthingItem의_textFields() {
        let sut = dummyPatchingItem.textFields
        let expectedResult: [(key:String, value: String)] = [
            ("title", "귀여운 바나나"),
        ("descriptions", "귀여운 바나나입니다."),
            ("price", "1000"),
            ("password", "1234")
        ]
        
        for i in 0..<sut.count {
            XCTAssertEqual(sut[i].key, expectedResult[i].key)
            XCTAssertEqual(sut[i].value, expectedResult[i].value)
        }
    }
    
    func test_PacthingItem의_fileFields() {
        let sut = dummyPatchingItem.fileFields
        let jpegData = UIImage(systemName: "zzz")!.jpegData(compressionQuality: 1)!
        let expectedResult: [(key:String, value: Data)] = [
            ("images[]", jpegData)
        ]
        
        for i in 0..<sut.count {
            XCTAssertEqual(sut[i].key, expectedResult[i].key)
            XCTAssertEqual(sut[i].value, expectedResult[i].value)
        }
    }
}
