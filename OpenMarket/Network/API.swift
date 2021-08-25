//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import UIKit

protocol API {
    func getItems(
        pageIndex: UInt,
        completionHandler: @escaping (Result<GoodsList, HttpError>) -> Void
    ) throws
    
    func getItem(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
    
    func postItem(
        item: ItemRequestable,
        images: [UIImage],
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
    
    func patchItem(
        itemId: Int,
        item: ItemRequestable,
        images: [UIImage]?,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
    
    func deleteItem(
        itemId: Int,
        item: ItemRequestable,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
}
