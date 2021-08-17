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
        from url: String,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    ) {
        let query = url
            .replacingOccurrences(of: HttpConfig.baseURL, with: "")
            .split(separator: "/")
        
        guard query.count == 2,
              let pageNumber = UInt(query[1]),
              query[0] == "items" else {
            let error = HttpError(message: HttpConfig.invailedPath)
            return completionHandler(.failure(error))
        }
        
        if pageNumber == 1 {
            return completionHandler(.success(itemList))
        } else {
            let emptyItemList = ItemList(page: Int(pageNumber), items: [])
            return completionHandler(.success(emptyItemList))
        }
    }
    
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
