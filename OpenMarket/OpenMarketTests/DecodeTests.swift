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
