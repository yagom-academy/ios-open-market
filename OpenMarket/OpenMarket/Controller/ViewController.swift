//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    enum ViewType: Int {
        case list
        case grid
    }
    
    let networkManager: NetworkManager = .init()
    var dataSource: UICollectionViewDiffableDataSource<Section, ProductData>!
    var productCollectionView: UICollectionView!
    var productList: ProductListData?
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl(items: ["list", "grid"])
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.titleView = segmentControl
        configureProductCollectionView(type: .list)
        networkManager.loadData(of: .productList(pageNumber: 1, itemsPerPage: 100), dataType: ProductListData.self) { result in
            switch result {
            case .success(let productList):
                self.productList = productList
                DispatchQueue.main.async {
                    self.configureDataSource()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureLayout(of type: ViewType) -> UICollectionViewCompositionalLayout {
        switch type {
        case .list:
            let configure = UICollectionLayoutListConfiguration(appearance: .plain)
            let layout = UICollectionViewCompositionalLayout.list(using: configure)
            return layout
        case .grid:
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let spacing = CGFloat(10)
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
            let layout = UICollectionViewCompositionalLayout(section: section)
            
            return layout
        }
    }
    
    func configureProductCollectionView(type: ViewType) {
        let layout = configureLayout(of: type)
        productCollectionView = UICollectionView(frame: .zero,
                                                 collectionViewLayout: layout)
        
        productCollectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(productCollectionView)
        NSLayoutConstraint.activate([
            productCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            productCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            productCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            productCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCell, ProductData> { cell, indexPath, product in
            var content = UIListContentConfiguration.cell()
            content.text = product.name

            if product.stock == 0 {
                cell.stockLabel.text = "품절"
                cell.stockLabel.textColor = .systemYellow
            } else {
                cell.stockLabel.text = "잔여수량: " + product.stock.description
                cell.stockLabel.textColor = .systemGray2
            }
            
            if product.price == product.bargainPrice {
                content.secondaryText = product.currencyAndPrice
            } else {
                content.secondaryAttributedText = product.currencyAndDiscountedPrice
            }
            
            content.secondaryTextProperties.color = .systemGray2
            cell.listContentView.configuration = content
            cell.accessories = [.disclosureIndicator()]
            
            self.networkManager.loadThumbnailImage(of: product.thumbnail) { result  in
                switch result {
                case .success(let image):
                    content.image = image
                    DispatchQueue.main.async {
                        if indexPath == self.productCollectionView.indexPath(for: cell) {
                            cell.listContentView.configuration = content
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }

        dataSource = UICollectionViewDiffableDataSource<Section, ProductData>(collectionView: productCollectionView) { collectionView, indexPath, product in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(productList!.pages)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
}
