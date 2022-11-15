//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Ash and som on 2022/11/15.
//

import XCTest

class OpenMarketTests: XCTestCase {
    var sut: Welcome!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        guard let dataAsset: NSDataAsset = NSDataAsset(name: "62cba0444113154855988ca5") else { return }
        
        do {
            self.sut = try JSONDecoder().decode(Welcome.self, from: dataAsset.data)
        } catch {
            print(error.localizedDescription)
        }
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    func test_Welcome타입에서_pageNo값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.pageNo
        
        // then
        XCTAssertEqual(result, 1)
    }
    
    func test_Welcome타입에서_itemsPerPage값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.itemsPerPage
        
        // then
        XCTAssertEqual(result, 20)
    }
    
    func test_Welcome타입에서_totalCount값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.totalCount
        
        // then
        XCTAssertEqual(result, 10)
    }
    
    func test_Welcome타입에서_offset값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.offset
        
        // then
        XCTAssertEqual(result, 0)
    }
    
    func test_Welcome타입에서_limit값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.limit
        
        // then
        XCTAssertEqual(result, 20)
    }
    
    func test_Welcome타입에서_lastPage값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.lastPage
        
        // then
        XCTAssertEqual(result, 1)
    }
    
    func test_Welcome타입에서_hasNext값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.hasNext
        
        // then
        XCTAssertFalse(result)
    }
    
    func test_Welcome타입에서_hasPrev값을불러왔을때_해당json데이터값이들어와야한다() {
        // given
        // when
        let result = sut.hasPrev
        
        // then
        XCTAssertFalse(result)
    }
}
