//
//  Authenticatable.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

protocol Authenticatable: Encodable {
  var password: String { get }
}
