//
//  Cache.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/27.
//

import Foundation

class Cache {
    
    static var shared = Cache()
    var pageDataList: [Int : ItemsOfPageReponse] = [:]
    var detailItemInformationList: [Int : InformationOfItemResponse] = [:]
    var numberOfItems = 0
    var maxPageNumber = 0
    var minPageNumber = 0
    var imageFiles: [String] = []
}
