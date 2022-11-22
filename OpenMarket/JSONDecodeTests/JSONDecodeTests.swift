//
//  OpenMarket - JSONDecodeTests.swift
//  Created by Zhilly, Dragon. 22/11/14
//  Copyright © yagom. All rights reserved.
//

import XCTest
@testable import OpenMarket

final class JSONDecodeTests: XCTestCase {
       
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_결과가nil이아닌지() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let result = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)

        //then - 결과가 nil이 아닌지
        XCTAssertNotNil(result)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_page_no가1와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.pageNumber
        
        //then - page_no가 1인지
        XCTAssertEqual(result, 1)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_items_per_page가2와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.itemsPerPage

        //then - itemsPerPage가 2인지
        XCTAssertEqual(result, 2)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_total_count가3와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.totalCount

        //then - totalCount가 3인지
        XCTAssertEqual(result, 3)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_offset가4와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.offset

        //then - offeset가 4인지
        XCTAssertEqual(result, 4)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_limit가5와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.limit

        //then - limit가 5인지
        XCTAssertEqual(result, 5)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_last_page가6와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.lastPage

        //then - lastPage가 1인지
        XCTAssertEqual(result, 6)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_has_next가false와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.hasNext

        //then - hasNext가 false인지
        XCTAssertEqual(result, false)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_has_prev가false와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let data = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)
        let result = data?.hasPrevious

        //then - hasPrevious가 1인지
        XCTAssertEqual(result, false)
    }
    
    func test_json파일이름이TestProduct이고_dataAsset을실행하면_pages의id가11와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let result = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)

        //then - @@가 @@인지
        XCTAssertEqual(result?.pages.first!.id, 11)
    }

    func test_json파일이름이TestProduct이고_dataAsset을실행하면_pages의name가nametest와같다() {
        //given - TestProduct.json 파일이 주어짐.
        let dataAssetName: String = "TestProduct"
        
        //when - decodeAsset을 했을때
        let result = JSONDecoder.decodeAsset(name: dataAssetName, to: ProductList.self)

        //then - @@가 @@인지
        XCTAssertEqual(result?.pages.first!.name, "name test")
    }
}
