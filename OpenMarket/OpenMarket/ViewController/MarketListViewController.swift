//
//  MarketListViewController.swift
//  OpenMarket
//
//  Created by 써니쿠키, 메네 on 2022/11/22.
//

import UIKit

final class MarketListViewController: UIViewController {
    private var pageData: [Page] = []
    private var listView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, Page>?
    
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
                    self.configureListView()
                    self.configureDataSource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureListView() {
        listView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        view.addSubview(listView)
    }
    
    private func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<MarketListCell, Page> {
            (cell, indexPath, page) in
            cell.configureCell(page: page) { updateConfiguration in
                if indexPath == self.listView.indexPath(for: cell) {
                    updateConfiguration()
                }
            }
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Page>(collectionView: listView) {
            (listView, indexPath, page) -> UICollectionViewCell? in
            return listView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                          for: indexPath,
                                                          item: page)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Page>()
        
        snapshot.appendSections([.productList])
        snapshot.appendItems(pageData)
        dataSource?.apply(snapshot)
    }
}

extension MarketListViewController {
    private enum Section {
        case productList
    }
}

