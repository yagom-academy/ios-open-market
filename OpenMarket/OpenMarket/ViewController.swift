//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

private enum Section: Hashable {
    case main
}

final class ViewController: UIViewController {
    private var listLayout: UICollectionViewLayout = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }()
    private var collectionView: UICollectionView? = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewsIfNeeded()
        configureDataSource()
    }
    
    private func setupViewsIfNeeded() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: listLayout)
        if let collectionView = collectionView {
            view.addSubview(collectionView)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            let safeArea = view.safeAreaLayoutGuide
            NSLayoutConstraint.activate([
                collectionView.topAnchor.constraint(equalTo: safeArea.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
            ])
        }
    }
}

extension ViewController {
    private func configureDataSource() {
        guard let collectionView = collectionView else {
            return
        }
        
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.updateWithProduct(product)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: Product) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        let dataAsset: NSDataAsset = NSDataAsset(name: "products")!
        let page: Page = try! JSONDecoder().decode(Page.self, from: dataAsset.data)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(page.products)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
