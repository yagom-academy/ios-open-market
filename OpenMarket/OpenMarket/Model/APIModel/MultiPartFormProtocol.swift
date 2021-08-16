//
//  MultiPartFormProtocol.swift
//  OpenMarket
//
//  Created by 오승기 on 2021/08/16.
//

import Foundation

protocol MultiPartFormProtocol: APIModelProtocol {
  var textField: [String: String?] {
    get
  }
  
  var images: [Data]? {
    get
  }
}
