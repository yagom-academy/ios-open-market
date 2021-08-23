//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import UIKit

protocol ClientAPI {
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<GoodsList, HttpError>) -> Void
    )
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    )
}


extension ClientAPI {
    func postItem(
        item: ItemRequestable,
        images: [UIImage],
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {}
    
    func patchItem(
        item: ItemRequestable,
        images: [UIImage],
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {}
    
    func deleteItem(
        itemId: Int,
        item: ItemRequestable,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) {
        
    }
}
