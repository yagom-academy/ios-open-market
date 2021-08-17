//
//  ListManagingMock.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/11.
//

import UIKit
@testable import OpenMarket

class SessionMock: Http, Decoder {
    
    typealias Model = ItemList

    private lazy var asset = try? takeAssetData(assetName: "item_list")
    lazy var itemList = try! parse(from: asset!, to: ItemList.self).get()
    
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    ) {
        if pageIndex == 1 {
            return completionHandler(.success(itemList))
        } else {
            let emptyItemList = ItemList(page: Int(pageIndex), items: [])
            return completionHandler(.success(emptyItemList))
        }
    }
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
        let assetData = try! takeAssetData(assetName: "item")
        let item = try! parse(from: assetData, to: ItemDetail.self).get()
        
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
