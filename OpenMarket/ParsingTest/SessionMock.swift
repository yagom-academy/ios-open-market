//
//  ListManagingMock.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/11.
//

import UIKit
@testable import OpenMarket

class SessionMock: ClientAPI {
    
    typealias Model = GoodsList

    private lazy var asset = try? takeAssetData(assetName: "item_list")
    lazy var itemList = try! Parser.decode(
        from: asset!,
        to: GoodsList.self,
        or: HttpError.self
    ).get()
    
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<GoodsList, HttpError>) -> Void
    ) {
        if pageIndex == 1 {
            return completionHandler(.success(itemList))
        } else {
            let emptyItemList = GoodsList(page: Int(pageIndex), items: [])
            return completionHandler(.success(emptyItemList))
        }
    }
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
        guard let assetData = try? takeAssetData(assetName: "item"),
              let item = try? Parser.decode(
                  from: assetData,
                  to: ItemDetail.self,
                  or: HttpError.self
              ).get() else {
            return
        }
        
        if id == 1 {
            completionHandler(.success(item))
        } else {
            completionHandler(.failure(HttpError(message: "there is no item")))
        }
    }
}

extension SessionMock {
    private func takeAssetData(assetName: String) throws -> Data {
        guard let convertedAsset = NSDataAsset(name: assetName) else {
            let debugDescription = "failed to take data from asset"
            let context = DecodingError.Context(
                codingPath: [],
                debugDescription: debugDescription
            )
            let error = DecodingError.valueNotFound(NSDataAsset.self, context)
            
            throw error
        }
        
        return convertedAsset.data
    }
}
