//
//  ItemSearcherProtocol.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/14.
//

import Foundation

protocol ItemSearcherProtocol {
  func search(id: Int, completionHandler: @escaping (ProductSearchResponse?) -> ())
}
