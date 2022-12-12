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
    
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Page>
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Page>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchMarketData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMarketData()
    }
    
    private func fetchMarketData() {
        let marketURLSessionProvider = MarketURLSessionProvider()
        
        guard let url = Request.productList(pageNumber: 1, itemsPerPage: 100).url else {
            print(NetworkError.generateUrlFailError)
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
                    self.configureListView()
                    self.configureDataSource()
                    self.applySnapshot()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureListView() {
        listView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        view.addSubview(listView)
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        
        return UICollectionViewCompositionalLayout.list(using: config)
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
        
        dataSource = DataSource(collectionView: listView) {
            (listView, indexPath, page) -> UICollectionViewCell? in
            return listView.dequeueConfiguredReusableCell(using: cellRegistration,
                                                          for: indexPath,
                                                          item: page)
        }
    }
    
    private func applySnapshot() {
        var snapshot = Snapshot()
        
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
