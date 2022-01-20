//
//  DataManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import Foundation

class ProductPageDataManager {
    
    private var networkManager: ProductNetworkManager<Page>
    
    private var pageNumber: Int = 1
    private var itemsPerPage: Int = 10
    private var page: Page? {
        didSet {
            dataChangedHandler?()
        }
    }
    private var itemsCount: String {
        return String(itemsPerPage)
    }
    
    var products: [Product] {
        return page?.pages ?? []
    }
    
    var dataChangedHandler: (() -> Void)?
    
    init(handler: (() -> Void)? = nil) {
        networkManager = ProductNetworkManager()
        networkManager.dataFetchHandler = self.fetchRequest
        networkManager.fetchPage(itemsPerPage: itemsCount)
        self.dataChangedHandler = handler
    }
    
    func requestNextPage() {
        guard let page = page, page.hasNext else { return }
        itemsPerPage += 4
        networkManager.fetchPage(itemsPerPage: String(itemsPerPage))
    }
    
    func update() {
        networkManager.fetchPage(itemsPerPage: itemsCount)
    }
    
    func fetchRequest(data: Page) {
        self.page = data
    }
    
    func reset() {
        itemsPerPage = 10
        page = nil
    }
    
}
