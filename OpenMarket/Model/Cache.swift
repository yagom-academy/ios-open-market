//
//  Cache.swift
//  OpenMarket
//
//  Created by 최정민 on 2021/05/27.
//

import Foundation

class Cache {
    static var shared = Cache()
    var itemDataList: [Item] = []
    var thumbnailImageDataList: [Data] = []
    var recentUpdatedItemDataCountOfItemDataList = 0
    var detailItemInformationList: [Int : InformationOfItemResponse] = [:]
    var numberOfItems = 0
    var maxPageNumber = 0
    var minPageNumber = 0
    var imageFiles: [String] = ["clear", "airpodMax", "imac1", "imac2", "imac3", "imac4", "imac5"]
}
