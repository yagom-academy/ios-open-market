//
//  Detailable.swift
//  OpenMarket
//
//  Created by 이영우 on 2021/05/13.
//

import Foundation

protocol Detailable: ListSearchable {
  var description: String { get }
  var images: [String] { get }
}
