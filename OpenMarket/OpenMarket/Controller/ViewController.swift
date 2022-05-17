//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum Section: Int {
    case main
}

final class ViewController: UIViewController {
    lazy var productView = ProductView.init(frame: view.bounds)
    typealias DataSource = UICollectionViewDiffableDataSource<Section, ProductsDetail>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ProductsDetail>
    private lazy var dataSource = makeDataSource()
    
    var item: [ProductsDetail] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    private func configureView() {
        self.view = productView
        view.backgroundColor = .white
        navigationItem.titleView = productView.segmentedControl
        navigationItem.rightBarButtonItem = productView.plusButton
        view.addSubview(productView.collectionView)
        productView.configureLayout()
    }
    
    func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: productView.collectionView,
            cellProvider: { (collectionView, indexPath, productDetail) -> UICollectionViewCell? in
                guard let cell = self.productView.collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as? CollectionViewCell else {
                    return UICollectionViewCell()
                }
                
                cell.productName.text = productDetail.name
                cell.currency.text = productDetail.currency
                cell.price.text = String(productDetail.price)
                cell.bargainPrice.text = String(productDetail.bargainPrice)
                cell.stock.text = String(productDetail.stock)
                
                return cell
            })
        return dataSource
    }
    
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapShot = Snapshot()
        snapShot.appendSections([Section.main])
        snapShot.appendItems(item, toSection: Section.main)
        dataSource.apply(snapShot, animatingDifferences: animatingDifferences)
    }
}
