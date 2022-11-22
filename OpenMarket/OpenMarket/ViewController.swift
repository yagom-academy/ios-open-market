//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum CollectionViewLayout {
    case list
    case grid
}

private enum Section: Hashable {
    case main
}

final class ViewController: UIViewController {
    private let listLayout: UICollectionViewLayout = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }()
    private let gridLayout: UICollectionViewLayout = {
        let spacing = CGFloat(10)
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                     leading: spacing,
                                                     bottom: 0,
                                                     trailing: 0)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(0.87))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        group.contentInsets = NSDirectionalEdgeInsets(top: spacing,
                                                      leading: 0,
                                                      bottom: 0,
                                                      trailing: spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                        leading: 0,
                                                        bottom: spacing,
                                                        trailing: 0)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }()
    private var currentLayout: CollectionViewLayout = .grid
    private var collectionView: UICollectionView? = nil
    private var dataSource: UICollectionViewDiffableDataSource<Section, Product>? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewsIfNeeded()
        configureDataSource()
    }
    
    private func setupViewsIfNeeded() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        collectionView?.backgroundColor = .white
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
        
        let listCellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, product) in
            cell.updateWithProduct(product)
            cell.accessories = [.disclosureIndicator()]
        }

        let gridCellRegistration = UICollectionView.CellRegistration<ProductGridCell, Product> { (cell, indexPath, product) in
            cell.updateWithProduct(product)
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, product: Product) -> UICollectionViewCell? in
            switch self.currentLayout {
            case .list:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: product)
            case .grid:
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration, for: indexPath, item: product)
            }
        }
        
        let dataAsset: NSDataAsset = NSDataAsset(name: "products")!
        let page: Page = try! JSONDecoder().decode(Page.self, from: dataAsset.data)
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(page.products)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}
