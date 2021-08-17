//
//  Http.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/17.
//

import Foundation

protocol Http {
    func httpGetItems(url: String) -> Result<ItemList, HttpError>
}
