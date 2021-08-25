//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import UIKit

protocol API {
    func getGoodsList(
        pageIndex: UInt,
        completionHandler: @escaping (Result<GoodsList, HttpError>) -> Void
    ) throws
    
    func getGoods(
        id: UInt,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
    
    func postGoods(
        item: ItemRequestable,
        images: [UIImage],
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
    
    func patchGoods(
        id: Int,
        item: ItemRequestable,
        images: [UIImage]?,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
    
    func deleteGoods(
        id: Int,
        item: ItemRequestable,
        completionHandler: @escaping (Result<ItemDetail, HttpError>) -> Void
    ) throws
}
