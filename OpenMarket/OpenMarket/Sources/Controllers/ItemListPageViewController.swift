//
//  OpenMarket - ItemListPageViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ItemListPageViewController: UIViewController {
    
    // MARK: - Properties

    private var itemListPage: ItemListPage?
    
    private lazy var request = Path.products + queryString
    private let queryString = QueryCharacter.questionMark + QueryKey.pageNumber + QueryValue.pageNumber + QueryCharacter.ampersand + QueryKey.itemsPerPage + QueryValue.itemsPerPage
    
    // MARK: - UI Components
    
    private let segmentedControl: UISegmentedControl = {
        let selectionItems = ["LIST", "GRID"]
        let segmentedControl = UISegmentedControl(items: selectionItems)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        
        return segmentedControl
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.performRequestToAPI(from: HostAPI.openMarket.url, with: request) { (result: Result<Data, NetworkingError>) in
            self.fetchParsedData(basedOn: result)
        }
        
        setUIComponentsLayout()
    }
}

// MARK: - Private Actions

private extension ItemListPageViewController {
    func setUIComponentsLayout() {
        self.view.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func fetchParsedData(basedOn result: Result<Data, NetworkingError>) {
        switch result {
        case .success(let data):
            itemListPage = NetworkManager.parse(data, into: ItemListPage.self)
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
