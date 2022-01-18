//
//  DataManager.swift
//  OpenMarket
//
//  Created by Jae-hoon Sim on 2022/01/14.
//

import UIKit

class DataManager {
    
    var itemsPerPage: Int = 20
    var lastLoadedPage: Int = 1
    var hasNextPage: Bool = true
    var products: [Product] = [] {
        didSet {
            delegate?.dataDidChange(data: products)
        }
    }
    
    weak var delegate: DataRepresentable?
    
    func nextPage() {
        if hasNextPage {
            lastLoadedPage += 1
            fetchPage()
        }
    }
    
    @objc
    func update() {
        fetchPage()
    }
    
    private func fetchPage() {
        URLSessionProvider(session: URLSession.shared)
            .request(.showProductPage(pageNumber: String(lastLoadedPage), itemsPerPage: String(itemsPerPage))) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
                switch result {
                case .success(let data):
                    self.hasNextPage = data.hasNext
                    self.delegate?.snapshot.appendItems(data.pages)
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}

protocol DataRepresentable: AnyObject {
    var snapshot: NSDiffableDataSourceSnapshot<Int, Product> { get set }
    func dataDidChange(data: [Product])
}
