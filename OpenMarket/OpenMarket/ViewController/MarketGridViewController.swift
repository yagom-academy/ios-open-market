//
//  MarketGridViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/23.
//

import UIKit

class MarketGridViewController: UIViewController {
    var gridCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Page>?
    var pageData: [Page] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(0.4))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .fractionalWidth(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureCollectionView() {
        gridCollectionView = UICollectionView(frame: view.bounds,
                                              collectionViewLayout: createGridLayout())
        view.addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MarketCollectionViewGridCell, Page> {
            cell, indexPath, page in
            cell.configureCell(page: page)
        }
        dataSource = UICollectionViewDiffableDataSource(collectionView: gridCollectionView,
                                                        cellProvider: {
            collectionView, indexPath, page in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: page)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
        snapshot.appendSections([.productGrid])
        snapshot.appendItems(pageData)
        dataSource?.apply(snapshot)
    }
}


extension MarketGridViewController {
    enum Section {
        case productGrid
    }
}
