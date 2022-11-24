//
//  MarketGridViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/23.
//

import UIKit

final class MarketGridViewController: UIViewController {
    private var gridView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Page>?
    private var pageData: [Page] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarketData()
    }
    
    private func fetchMarketData() {
        let marketURLSessionProvider = MarketURLSessionProvider()
        
        guard let url = Request.productList(pageNumber: 1, itemsPerPage: 100).url else { return }
        
        marketURLSessionProvider.fetchData(url: url, type: Market.self) { result in
            switch result {
            case .success(let market):
                self.pageData = market.pages
                DispatchQueue.main.async {
                    self.setupGridFrameLayout()
                    self.configureDataSource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func setupGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(350))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item,
                                                       count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func setupGridFrameLayout() {
        gridView = UICollectionView(frame: view.bounds,
                                    collectionViewLayout: setupGridLayout())
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.topAnchor),
            gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MarketGridCell, Page> {
            cell, indexPath, page in
            cell.configureCell(page: page,
                               collectionView: self.gridView,
                               indexPath: indexPath,
                               cell: cell)
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: gridView,
                                                        cellProvider: {
            gridView, indexPath, page in
            return gridView.dequeueConfiguredReusableCell(using: cellRegistration,
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
    private enum Section {
        case productGrid
    }
}
