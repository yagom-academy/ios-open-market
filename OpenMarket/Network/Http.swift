//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import UIKit

protocol Http {
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    )
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    )
}


extension Http {
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
