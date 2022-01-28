//
//  DataManager.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/14.
//

import Foundation

class ProductPageDataManager {
    
    private let networkManager = ProductNetworkManager.shared
    
    private var pageInfo: (currentPage: Int, itemsPerPage: Int) = (1, 10) {
        didSet { update() }
    }
    
    private var page: Page? {
        didSet { modelHandler() }
    }
    
    private let modelHandler: () -> Void
    
    init(modelHandler: @escaping () -> Void) {
        self.modelHandler = modelHandler
    }
    
    func nextPage() {
        guard let page = page, page.hasNext else { return }
        pageInfo.itemsPerPage += 4
    }
    
    func reset() {
        pageInfo = (1, 10)
        page = nil
    }
    
    func update() {
        networkManager.fetchPage(
            pageNumber: pageNumberString,
            itemsPerPage: itemsPerPageString,
            completionHandler: update
        )
    }
    
    private func update(page: Page) {
        self.page = page
    }
    
}

// MARK: - Property Type Convert Utilities
extension ProductPageDataManager {
    
    private var pageNumberString: String {
        String(pageInfo.currentPage)
    }
    
    private var itemsPerPageString: String {
        String(pageInfo.itemsPerPage)
    }
    
    var products: [Product] {
        return page?.pages ?? []
    }
    
}
