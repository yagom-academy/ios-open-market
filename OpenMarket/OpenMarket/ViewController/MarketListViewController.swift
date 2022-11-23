//
//  MarketListViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

class MarketListViewController: UIViewController {
    var pageData: [Page] = []
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Page>?

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarketData()
    }
    
    func fetchMarketData() {
        let marketURLSessionProvider = MarketURLSessionProvider()
        
        guard let url = Request.productList(pageNumber: 1, itemsPerPage: 50).url else { return }
        
        marketURLSessionProvider.fetchData(url: url, type: Market.self) { result in
            switch result {
            case .success(let market):
                self.pageData = market.pages
                DispatchQueue.main.async {
                    self.configureCollectionView()
                    self.configureDataSource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func createListLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds,
                                          collectionViewLayout: createListLayout())
        view.addSubview(collectionView)
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MarketCollectionViewListCell, Page> {
            (cell, indexPath, page) in
            cell.update(with: page)
            cell.accessories = [.disclosureIndicator()]
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView:
                                                                        collectionView) {
            (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
        snapshot.appendSections([.productList])
        snapshot.appendItems(pageData)
        dataSource?.apply(snapshot)
    }
}

extension MarketListViewController {
    enum Section {
        case productList
    }
}

