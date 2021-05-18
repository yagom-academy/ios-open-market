//
//  SessionManagerTests.swift
//  OpenMarketTests
//
//  Created by 천수현 on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class SessionManagerHTTPTests: XCTestCase {
    var sut = SessionManager.shared
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
                                         currency: "KRW",
                                         stock: 10,
                                         discountedPrice: nil,
                                         images: [],
                                         password: "1234")
        
    }

    override func tearDownWithError() throws {
        dummyPostingItem = nil
        dummyPatchingItem = nil
    }
    
    func test_request_get_호출시_completionHandler에_Item이_인자로_전달된다() {
        
    }
    
    func test_request_get_호출시_completionHandler에_Page가_인자로_전달된다() {
        
    }
    
    func test_request_post_호출시_completionHandler에_post된_Item이_인자로_전달된다() {
        
    }
    
    func test_request_patch_호출시_completionHandler에_patch된_Item이_인자로_전달된다() {
        
    }
    
    func test_request_delete_호출시_completionHandler에_삭제된_Item이_인자로_전달된다() {
        
    }
}
