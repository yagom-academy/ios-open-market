//
//  OpenMarket - ItemListPageViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ItemListPageViewController: UIViewController {
    
    // MARK: - Properties
    
    private var itemListPage: ItemListPage?
    
    private lazy var url = Path.products + queryString
    private let queryString = QueryCharacter.questionMark + QueryKey.pageNumber + QueryValue.pageNumber + QueryCharacter.ampersand + QueryKey.itemsPerPage + QueryValue.itemsPerPage
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataManager.performRequestToAPI(with: url) { (result: Result<Data, NetworkingError>) in
            self.fetchParsedData(basedOn: result)
        }
    }
}

// MARK: - Private Actions

private extension ItemListPageViewController {
    func fetchParsedData(basedOn result: Result<Data, NetworkingError>) {
        switch result {
        case .success(let data):
            itemListPage = DataManager.parse(data, into: ItemListPage.self)
        case .failure(let error):
            print(error)
        }
    }
}

// MARK: - Private Enums

private extension ItemListPageViewController {
    enum QueryValue {
        static var pageNumber = "1"
        static var itemsPerPage = "10"
    }
    
    enum QueryKey {
        static var pageNumber = "page_no="
        static var itemsPerPage = "items_per_page="
    }
    
    enum Path {
        static var products = "/api/products"
    }
    
    enum QueryCharacter {
        static var questionMark = "?"
        static var ampersand = "&"
    }
}
