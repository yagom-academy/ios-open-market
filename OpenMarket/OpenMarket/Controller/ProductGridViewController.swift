//
//  ProductGridViewController.swift
//  OpenMarket
//
//  Created by jin on 11/23/22.
//

import UIKit

class ProductGridViewController: UIViewController {

    var gridCollectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var productData: ProductList?


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let networkProvider = NetworkAPIProvider()
        networkProvider.fetchProductList(query: nil) { result in
            switch result {
            case .success(let data):
                self.productData = data
                DispatchQueue.main.async {
                    self.createGridCollectionView()
                    self.configureDataSource()
                }
            default :
                return
            }
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout{ 
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height * 0.25))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let layout = UICollectionViewCompositionalLayout(section: section)

        return layout
    }

    func createGridCollectionView() {
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())

        view.addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureDataSource() {
        // 5-1. `CellRegistration` 구현
        let cellRegistration = UICollectionView.CellRegistration<ProductListCell, Product> { cell, indexPath, product in
            cell.update(with: product)
        }

        // 5-2. `UICollectionViewDiffableDataSource` 인스턴스 생성 및 cellProvider의 `dequeueConfiguredReusableCell` 구현
        dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: gridCollectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })

        // 5-3. `NSDiffableDataSourceSnapShot` 생성
        var snapShot = NSDiffableDataSourceSnapshot<Section, Product>()
        snapShot.appendSections([.main])
        snapShot.appendItems(productData?.pages ?? [])
        dataSource.apply(snapShot)
    }
}
