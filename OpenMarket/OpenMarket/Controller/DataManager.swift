//
//  DataManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import Foundation

class DataManager {
    
    var itemsPerPage: Int = 20
    var page: Page?
    var products: [Product] = [] {
        didSet {
            delegate?.dataDidChange(data: products)
        }
    }
    
    weak var delegate: DataRepresentable?
    
    func nextPage() {
        guard let page = page else { return }
        if page.hasNext {
            itemsPerPage += 20
            fetchPage()
        }
    }
    
    func update() {
        fetchPage()
    }
    
    private func fetchPage() {
        URLSessionProvider(session: URLSession.shared)
            .request(.showProductPage(pageNumber: "1", itemsPerPage: String(itemsPerPage))) {  (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
                switch result {
                case .success(let data):
                    self.page = data
                    self.products = data.pages
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}

protocol DataRepresentable: AnyObject {
    func dataDidChange(data: [Product])
}
