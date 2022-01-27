//
//  ProductPageViewModel.swift
//  OpenMarket
//
//  Created by JeongTaek Han on 2022/01/27.
//

import UIKit

class ProductPageViewModel {
    
    private lazy var model = ProductPageDataManager(modelHandler: self.viewHandler)
    
    private let viewHandler: () -> Void
    
    init(viewHandler: @escaping () -> Void) {
        self.viewHandler = viewHandler
    }
    
    let listCellRegistration: OpenMarketListCellRegistration = {
        let cellRegistration = OpenMarketListCellRegistration { (cell, indexPath, item) in
            cell.configureContents(at: indexPath, with: item)
            cell.layer.borderWidth = 0.3
            cell.layer.borderColor = UIColor.systemGray.cgColor
        }
        return cellRegistration
    }()
    
    let gridCellRegistration: OpenMarketGridCellRegistration = {
        let cellRegistration = OpenMarketGridCellRegistration { (cell, indexPath, item) in
            cell.configureContents(at: indexPath, with: item)
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 1.0
            cell.layer.borderColor = UIColor.systemGray.cgColor
        }
        return cellRegistration
    }()
    
    var snapshot: OpenMarketSnapshot {
        var snapshot = OpenMarketSnapshot()
        let products = model.products
        snapshot.appendSections([0])
        snapshot.appendItems(products)
        return snapshot
    }
    
    func viewDidLoad() {
        update()
    }
    
    func update() {
        model.update()
    }
    
    func reset() {
        model.reset()
    }
    
    func refresh() {
        reset()
        update()
    }
    
    func nextPage() {
        model.nextPage()
    }
    
}
