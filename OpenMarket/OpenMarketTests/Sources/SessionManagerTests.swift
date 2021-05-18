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
    
    func test_get_성공시_completionHandler의_인자로_success가_전달된다() {
        let expectation = XCTestExpectation()
        
        sut.get(id: 63) { (result: Result<Item, SessionManager.Error>) in
            let a = try! result.get()
            XCTAssertEqual(a.title, "Neph")
            
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_JSON_data로_변환할_수_없다면_get_completionHandler의_인자로_failure_dataIsNotJSON이_전달된다() {
        let expectation = XCTestExpectation()
        
        sut.get(id: -1) { (result: Result<Page, SessionManager.Error>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTAssertEqual(error, SessionManager.Error.dataIsNotJSON)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_postItem_성공시_completionHandler의_인자로_success가_전달된다() {
        let expectation = XCTestExpectation()
        
        sut.postItem(dummyPostingItem) { (result: Result<Item, SessionManager.Error>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_patchItem_성공시_completionHandler의_인자로_success가_전달된다() {
        let expectation = XCTestExpectation()
        let itemId = 134
        
        sut.patchItem(id: itemId, patchingItem: dummyPatchingItem) { (result: Result<Item, SessionManager.Error>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                XCTFail(error.localizedDescription)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 10)
    }
    
    func test_id나_password가_틀릴_경우_patchItem_completionHandler의_인자로_failure_invalidIDOrPassword가_전달된다() {
        let expectation = XCTestExpectation()
        let itemId = 53
        
        sut.patchItem(id: itemId, patchingItem: dummyPatchingItem) { (result: Result<Item, SessionManager.Error>) in
            switch result {
            case .success:
                XCTFail("성공했음")
            case .failure(let error):
                if error != .invalidIDOrPassword {
                    XCTFail(error.localizedDescription)
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_delete_성공시_completionHandler가_호출된다() {
        let expectation = XCTestExpectation()
        
        sut.deleteItem(id: 180, password: "1234") { (result: Result<Item, SessionManager.Error>) in
            switch result {
            case .success:
                break
            case .failure(let error):
                if error != .invalidIDOrPassword {
                    XCTFail(error.localizedDescription)
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func test_잘못된_id나_password로_delete_시도시_completionHandler의_인자로_failure_invalidIDOrPassword가_전달된다() {
        let expectation = XCTestExpectation()
        
        sut.deleteItem(id: 1, password: "1234") { (result: Result<Item, SessionManager.Error>) in
            switch result {
            case .success:
                XCTFail("success가 전달됨")
            case .failure(let error):
                if error != .invalidIDOrPassword {
                    XCTFail(error.localizedDescription)
                }
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
