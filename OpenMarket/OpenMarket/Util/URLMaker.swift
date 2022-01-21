//
//  URLMaker.swift
//  OpenMarket
//
//  Created by Eunsoo KIM on 2022/01/19.
//

import Foundation

enum URLMaker {
  private static let hostURL = "https://market-training.yagom-academy.kr"
  private static let hostPath = "/api/products"
  
  static func itemListURL(pageNo: Int, itemsPerPage: Int) -> URL? {
    let address = hostURL + hostPath + "?page_no=" + "\(pageNo)" + "&items_per_page=" + "\(itemsPerPage)"
    
    return URL(string: address)
  }
  
  static func itemInfoURL(itemId: Int) -> URL {
    let address = hostURL + hostPath + "/\(itemId)"
    
    guard let url = URL(string: address) else {
      return URL(string: "")!
    }
    return url
  }
}
