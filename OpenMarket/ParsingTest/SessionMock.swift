//
//  ListManagingMock.swift
//  ParsingTest
//
//  Created by 수박, ehd on 2021/08/11.
//

import Foundation
@testable import OpenMarket

class SessionMock: Http,  Decoder {
    typealias Model = ItemList
    
    private lazy var asset = try? takeAssetData(assetName: "item_list")
    lazy var itemList = try! parse(from: asset!, to: ItemList.self).get()
    
    func httpGetItems(url: String) -> Result<ItemList, HttpError> {
        let query = url
            .replacingOccurrences(of: HttpConfig.baseURL, with: "")
            .split(separator: "/")
        
        guard query.count == 2,
              let pageNumber = UInt(query[1]),
              query[0] == "items" else {
            return .failure(HttpError(message: HttpConfig.invailedPath))
        }
        
        if pageNumber == 1 {
            return .success(itemList)
        } else {
            return .success(ItemList(page: Int(pageNumber), items: []))
        }
    }
}
