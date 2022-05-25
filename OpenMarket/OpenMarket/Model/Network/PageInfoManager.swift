//
//  PageInfoManager.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/25.
//

import Foundation

struct PageInfoManager {
    
    private(set) var currentPage: Int
    private(set) var itemsPerPage: Int
    var currentPageInformationUrl: URL? {
        get {
            return OpenMarketApi.pageInformation(pageNo: currentPage, itemsPerPage: itemsPerPage).url
        }
    }
    
    init(page: Int = 1, itmesPerPage: Int = 40) {
        self.currentPage = page
        self.itemsPerPage = itmesPerPage
    }
    
    @discardableResult
    mutating func goNextPage() -> Int {
        self.currentPage = currentPage + 1
        return currentPage
    }
}
