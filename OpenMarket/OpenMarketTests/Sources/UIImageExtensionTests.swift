//
//  UIImageExtensionTests.swift
//  OpenMarketTests
//
//  Created by duckbok on 2021/05/13.
//

import XCTest
@testable import OpenMarket

class UIImageExtensionTests: XCTestCase {
    func test_존재하지_않는_URL이라면_이미지_생성에_실패한다() {
        XCTAssertNil(UIImage.fetchImageFromURL(url: "나 URL 아님"))
    }

    func test_해당_URL이_이미지데이터가_아니라면_이미지_생성에_실패한다() {
        XCTAssertNil(UIImage.fetchImageFromURL(url: "https://camp-open-market-2.herokuapp.com/items/1"))
    }

    func test_올바른_이미지_URL이라면_이미지_생성에_성공한다() {
        XCTAssertNotNil(UIImage.fetchImageFromURL(url: "https://camp-open-market.s3.ap-northeast-2.amazonaws.com/thumbnails/1-1.png"))
    }
}
