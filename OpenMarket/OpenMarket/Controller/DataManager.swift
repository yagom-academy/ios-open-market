//
//  DataManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import Foundation

class DataManager: NetworkManagerDelegate {
    
    private var networkManager: NetworkManager
    
    private var pageNumber: Int = 1
    private var itemsPerPage: Int = 10
    private var page: Page? {
        didSet {
            NotificationCenter.dataManager.post(name: .dataDidChanged, object: nil)
        }
    }
    private var itemsCount: String {
        return String(itemsPerPage)
    }
    
    var products: [Product] {
        return page?.pages ?? []
    }
    
    init() {
        networkManager = NetworkManager()
        networkManager.delegate = self
        networkManager.fetchPage(itemsPerPage: itemsCount)
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
