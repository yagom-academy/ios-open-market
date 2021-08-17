//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

protocol Http {
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    )
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<Item, HttpError>) -> Void
    )
}


extension Http {
    func postItem(){}
    func patchItem(){}
    func deleteItem(){}
}
