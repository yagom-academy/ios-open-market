//
//  OpenMarketTests.swift
//  OpenMarketTests
//
//  Created by Yeon on 2021/01/26.
//

import XCTest
@testable import OpenMarket

class OpenMarketTests: XCTestCase {
    private var itemList: ItemList?
    private var item: Item?
    
    func testGetItemListAsync() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")

        ItemManager.loadData(path: .items, param: 1) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    itemList = try JSONDecoder().decode(ItemList.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }

        wait(for: [expectation], timeout: 5.0)
        let page = itemList?.page
        let itemId = itemList?.items[0].id
        let itemTitle = itemList?.items[0].title
        let itemPrice = itemList?.items[0].price
        let itemCurrency = itemList?.items[0].currency
        let itemStock = itemList?.items[0].stock

        XCTAssertEqual(page, 1)
        XCTAssertEqual(itemId, 26)
        XCTAssertEqual(itemTitle, "MacBook Air")
        XCTAssertEqual(itemPrice, 1290000)
        XCTAssertEqual(itemCurrency, "KRW")
        XCTAssertEqual(itemStock, 1_000_000_000_000)
    }
    
    func testGetItemDetail() {
        let expectation = XCTestExpectation(description: "APIPrivoderTaskExpectation")
        ItemManager.loadData(path: .item, param: 68) { [self] result in
            switch result {
            case .success(let data):
                guard let data = data else {
                    return
                }
                do {
                    item = try JSONDecoder().decode(Item.self, from: data)
                    expectation.fulfill()
                } catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
        
        wait(for: [expectation], timeout: 5.0)
        let id = item?.id
        let title = item?.title
        let price = item?.price
        let currency = item?.currency
        let stock = item?.stock
        
        XCTAssertEqual(id, 68)
        XCTAssertEqual(title, "Mac mini")
        XCTAssertEqual(price, 890000)
        XCTAssertEqual(currency, "KRW")
        XCTAssertEqual(stock, 90)
    }
}
