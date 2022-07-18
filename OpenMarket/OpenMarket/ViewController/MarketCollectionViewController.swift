//
//  File.swift
//  OpenMarket
//
//  Created by 주디, 재재 on 2022/07/15.
//

import UIKit

class MarketCollectionViewController: UICollectionViewController {
    enum Section: Hashable {
        case main
    }
    
    typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    lazy var dataSource = makeDataSource()
    private var items: [Item] = []
    private let sessionManager = URLSessionManager(session: URLSession.shared)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()
        receivePageData()
    }
    
    func createLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
}

extension MarketCollectionViewController {
    func makeDataSource() -> DataSource {
        let registraioin = productCellRegistration()
        
        return DataSource(collectionView: collectionView) { collectionView, indexPath, item -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: registraioin, for: indexPath, item: item)
        }
    }
    
    func productCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        return .init { cell, _, item in
            var configuration = cell.defaultContentConfiguration()
            
            configuration.text = item.productName
            configuration.secondaryText = item.price
            configuration.imageProperties.maximumSize = CGSize(width: 50, height: 50)
  
            self.sessionManager.receiveData(baseURL: item.productImage) { result in
                switch result {
                case .success(let data):
                    guard let imageData = UIImage(data: data) else { return }
                    
                    configuration.image = imageData
                    
                    DispatchQueue.main.async {
                        cell.contentConfiguration = configuration
                    }
                case .failure(_):
                    print("서버 통신 실패")
                }
            }
            
            cell.accessories = [.disclosureIndicator()]
        }
    }
    
    func applySnapshots() {
        var itemSnapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        itemSnapshot.appendSections([.main])
        itemSnapshot.appendItems(items)
        dataSource.apply(itemSnapshot, animatingDifferences: false)
    }
    
    func receivePageData() {
        let subURL = SubURL().pageURL(number: 1, countOfItems: 20)

        sessionManager.receiveData(baseURL: subURL) { result in
            switch result {
            case .success(let data):
                guard let page = DataDecoder().decode(type: Page.self, data: data) else { return }
                
                self.items = page.pages.map {
                    Item(product: $0 )
                }
                
                DispatchQueue.main.async {
                    self.applySnapshots()
                }
            case .failure(_):
                print("서버 통신 실패")
            }
        }
    }
}
