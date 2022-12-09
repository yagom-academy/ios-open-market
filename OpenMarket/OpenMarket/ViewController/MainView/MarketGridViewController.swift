//
//  MarketGridViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/23.
//

import UIKit

final class MarketGridViewController: UIViewController {
    private var gridView: UICollectionView!
    private var dataSource: DataSource?
    private var pageData: [Page] = []
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Page>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Page>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarketData()
    }
    
    private func fetchMarketData() {
        let marketURLSessionProvider = MarketURLSessionProvider()
        
        guard let url = Request.productList(pageNumber: 1, itemsPerPage: 100).url else {
            print(NetworkError.generateUrlFailError.localizedDescription)
            return
        }
        
        marketURLSessionProvider.fetchData(request: URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let marketData = JSONDecoder.decodeFromSnakeCase(type: Market.self,
                                                                       from: data) else {
                    print(NetworkError.dataDecodingFailError.localizedDescription)
                    return
                }
                self.pageData = marketData.pages
                DispatchQueue.main.async {
                    self.setupGridLayout()
                    self.configureDataSource()
                    self.applySnapshot()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func setupGridLayout() {
        gridView = UICollectionView(frame: view.bounds,
                                    collectionViewLayout: generateGridLayout())
        view.addSubview(gridView)
        gridView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridView.topAnchor.constraint(equalTo: view.topAnchor),
            gridView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func generateGridLayout() -> UICollectionViewCompositionalLayout {
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
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MarketGridCell, Page> {
            cell, indexPath, page in
            cell.configureCell(page: page) { updateImage in
                if indexPath == self.gridView.indexPath(for: cell) {
                    updateImage()
                }
            }
        }
        
        dataSource = DataSource(collectionView: gridView, cellProvider: {
            gridView, indexPath, page in
            return gridView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                          for: indexPath,
                                                          item: page)
        })
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        
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
