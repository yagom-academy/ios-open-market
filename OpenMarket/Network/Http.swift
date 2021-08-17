//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

protocol Http {
    func getItems(
        from url: String,
        completionHandler: @escaping (Result<ItemList, HttpError>) -> Void
    )
}
