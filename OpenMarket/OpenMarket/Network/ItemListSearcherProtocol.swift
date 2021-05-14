//
//  ItemListSearcherProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

protocol ItemListSearcherProtocol {
  func search(page: Int, completionHandler: @escaping (ListSearchResponse?) -> ())
}
