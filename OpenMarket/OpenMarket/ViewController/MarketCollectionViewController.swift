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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = createLayout()

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
            configuration.image = item.productImage
            configuration.imageProperties.maximumSize = CGSize(width: 40, height: 40)
            
            cell.contentConfiguration = configuration
            
            let disclosureAccessory = UICellAccessory.disclosureIndicator()
            cell.accessories = [disclosureAccessory]
        }
    }
    
    func receivePageData() {
        let sut = URLSessionManager(session: URLSession.shared)
        let subURL = SubURL().pageURL(number: 1, countOfItems: 10)
        let dataDecoder = DataDecoder()
        
        sut.receiveData(baseURL: subURL) { result in
            switch result {
            case .success(let data):
                guard let page = dataDecoder.decode(type: Page.self, data: data) else {
                    return
                }
                var items: [Item] = page.pages.map {
                    Item(product: $0 )
                }
            case .failure(_):
                print("서버 데이터 불일치 오류")
            }
        }
    }
}
