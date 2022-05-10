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
  
  func testDecode_Mock데이터가제공될때_Product의데이터가같아야한다() {
    // given
    guard let asset = NSDataAsset(name: "products") else { return XCTFail() }
    let input = Product(
      id: 20,
      vendorId: 3,
      name: "Test Product",
      thumbnail: "https://s3.ap-northeast-2.amazonaws.com/media.yagom-academy.kr/training-resources/3/thumb/5a0cd56b6d3411ecabfa97fd953cf965.jpg",
      currency: .krw,
      price: 0,
      bargainPrice: 0,
      discountedPrice: 0,
      stock: 0,
      createdAt: "2022-01-04T00:00:00.00",
      issuedAt: "2022-01-04T00:00:00.00")
    // when
    let reponse = try? JSONDecoder().decode(APIResponse.self, from: asset.data)
    let output = reponse?.pages.first
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

extension Product: Equatable {
  public static func == (lhs: Product, rhs: Product) -> Bool {
    let id = lhs.id == rhs.id
    let vendorId = lhs.vendorId == rhs.vendorId
    let name = lhs.name == rhs.name
    let thumbnail = lhs.thumbnail == rhs.thumbnail
    let currency = lhs.currency == rhs.currency
    let price = lhs.price == rhs.price
    let bargainPrice = lhs.bargainPrice == rhs.bargainPrice
    let discountedPrice = lhs.discountedPrice == rhs.discountedPrice
    let stock = lhs.stock == rhs.stock
    let createdAt = lhs.createdAt == rhs.createdAt
    let issuedAt = lhs.issuedAt == rhs.issuedAt
    return id && vendorId && name && thumbnail && currency && price && bargainPrice && discountedPrice && stock && createdAt && issuedAt
  }
}
