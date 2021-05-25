//
//  OpenMarketServiceProtocol.swift
//  OpenMarket
//
//  Created by duckbok on 2021/05/25.
//

import Foundation

protocol OpenMarketServiceProtocol {
    func getPage(id: Int, completionHandler: @escaping (Result<Page, OpenMarketError>) -> Void)
    func getItem(id: Int, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void)
    func postItem(completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void)
    func patchItem(id: Int, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void)
    func deleteItem(id: Int, completionHandler: @escaping (Result<Item, OpenMarketError>) -> Void)
}
