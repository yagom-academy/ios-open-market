//
//  DataManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import Foundation

class DataManager: NetworkManagerDelegate {
    
    private var networkManager: NetworkManager
    
    var pageNumber: Int = 1
    var itemsPerPage: Int = 20
    var page: Page?
    var products: [Product] = []
    
    var itemsCount: String {
        return String(itemsPerPage)
    }
    
    init() {
        networkManager = NetworkManager()
        networkManager.delegate = self
        networkManager.fetchPage(itemsPerPage: itemsCount)
    }
    
    func requestNextPage() {
        guard let page = page, page.hasNext else { return }
        itemsPerPage += 20
        networkManager.fetchPage(itemsPerPage: String(itemsPerPage))
    }
    
    func update() {
        networkManager.fetchPage(itemsPerPage: itemsCount)
    }
    
    func fetchRequest(data: Page) {
        self.page = data
        self.products = data.pages
        NotificationCenter.dataManager.post(name: .dataDidChanged, object: nil)
    }
    
}

protocol NetworkManagerDelegate: AnyObject {
    
    func fetchRequest(data: Page)
    
}

extension NotificationCenter {
    
    static let dataManager = NotificationCenter()
    
}

extension Notification.Name {
    
    static let dataDidChanged = Notification.Name("dataDidChanged")
    
}
