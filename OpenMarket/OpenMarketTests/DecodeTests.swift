//
//  DecodeTests.swift
//  DecodeTests
//
//  Created by Lingo, Quokka on 2022/05/10.
//

import XCTest
@testable import OpenMarket

final class DecodeTests: XCTestCase {
  override func setUpWithError() throws {
    try super.setUpWithError()
  }
  
  override func tearDownWithError() throws {
    try super.tearDownWithError()
  }
  
  func testDecode_Mock데이터가제공될때_APIResponse타입으로디코딩이성공해야한다() {
    // given
    guard let asset = NSDataAsset(name: "products") else { return XCTFail() }
    // when
    let output = try? JSONDecoder().decode(APIResponse.self, from: asset.data)
    // then
    XCTAssertNotNil(output)
  }
  
  func testDecode_Mock데이터가제공될때_APIResponse의데이터가같아야한다() {
    // given
    guard let asset = NSDataAsset(name: "products") else { return XCTFail() }
    let input = APIResponse(
      pageNo: 1,
      itemsPerPage: 20,
      totalCount: 10,
      offset: 0,
      limit: 20,
      pages: [],
      lastPage: 1,
      hasNext: false,
      hasPrev: false)
    // when
    let output = try? JSONDecoder().decode(APIResponse.self, from: asset.data)
    // then
    XCTAssertEqual(input, output)
  }
}

// MARK: - APIResponse

extension APIResponse: Equatable {
  public static func == (lhs: APIResponse, rhs: APIResponse) -> Bool {
    let pageNo = lhs.pageNo == rhs.pageNo
    let itemsPerPage = lhs.itemsPerPage == rhs.itemsPerPage
    let totalCount = lhs.totalCount == rhs.totalCount
    let offset = lhs.offset == rhs.offset
    let limit = lhs.limit == rhs.limit
    let lastPage = lhs.lastPage == rhs.lastPage
    let hasNext = lhs.hasNext == rhs.hasNext
    let hasPrev = lhs.hasPrev == rhs.hasPrev
    return pageNo && itemsPerPage && totalCount && offset && limit && lastPage && hasNext && hasPrev
  }
}
