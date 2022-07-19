//
//  OpenMarket - ViewController.swift
//  Created by 케이, 수꿍.
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MarketProductsViewController: UIViewController {
    enum Section {
        case main
    }
    
    private var productDataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>? = nil
    private var productCollectionView: UICollectionView! = nil
    private let segmentedControl = UISegmentedControl(items: ["List","Grid"])
    
    private let networkProvider = NetworkProvider()
    private var productsModel: [ProductEntity] = []
    
    private var isSelected: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        fetchData()
    }
}

// MARK: Networking

extension MarketProductsViewController {
    func fetchData() {
        self.networkProvider.requestAndDecode(url: "https://market-training.yagom-academy.kr/api/products?page_no=1&items_per_page=10", dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                productList.pages.forEach { product in
                    let item = ProductEntity(thumbnailImage: product.thumbnailImage!, name: product.name, originalPrice: product.price, discountedPrice: product.bargainPrice, stock: product.stock)
                    self.productsModel.append(item)
                    
                    DispatchQueue.main.async { [weak self] in
                        self?.configureSegmentedControl()
                        self?.configureHierarchy()
                        self?.configureDataSource()
                        self?.productCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                let alertController = UIAlertController(title: "알림", message: error.errorDescription, preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            }
        }
    }
}

// MARK: Configure CollectionView Layout

private extension MarketProductsViewController {
     func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 4, leading: 8, bottom: 4, trailing: 8)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.8))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

// - MARK: Configure UI Elements

private extension MarketProductsViewController {
    func configureHierarchy() {
        productCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        productCollectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        productCollectionView.backgroundColor = .systemBackground
        
        view.addSubview(productCollectionView)
    }
    
    func configureSegmentedControl() {
        let xPostion:CGFloat = 65
        let yPostion:CGFloat = 55
        let elementWidth:CGFloat = 150
        let elementHeight:CGFloat = 30
        
        segmentedControl.frame = CGRect(x: xPostion, y: yPostion, width: elementWidth, height: elementHeight)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.tintColor = UIColor.yellow
        segmentedControl.backgroundColor = UIColor.white
        segmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        configureNavigationItems()
    }
    
    func configureNavigationItems() {
        self.navigationItem.titleView = segmentedControl
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    func configureDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductEntity>()
        snapshot.appendSections([.main])
        
        let cellListRegistration = UICollectionView.CellRegistration<ProductCollectionViewCell, ProductEntity> { (cell, indexPath, item) in
            cell.configure(item)
            
            if self.isSelected == false {
                cell.accessories = [.disclosureIndicator()]
            } else {
                cell.accessories = [.delete()]
            }
        }
        
        productDataSource = UICollectionViewDiffableDataSource<Section, ProductEntity>(collectionView: productCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductEntity) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellListRegistration, for: indexPath, item: identifier)
        }
        
        snapshot.appendItems(productsModel)
        
        productDataSource?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: UIElements Action

private extension MarketProductsViewController {
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!) {
        let items = sender.selectedSegmentIndex
        
        switch items {
        case 0 :
            productCollectionView.setCollectionViewLayout(createListLayout(), animated: true)
            productCollectionView.visibleCells.forEach { cell in
                guard let cell = cell as? ProductCollectionViewCell else {
                    return
                }
                
                cell.contentView.layer.borderColor = .none
                cell.contentView.layer.borderWidth = 0
                cell.accessories = [.disclosureIndicator()]
                
                cell.configureStackView(of: .horizontal, textAlignment: .left)
            }
        case 1:
            productCollectionView.setCollectionViewLayout(createGridLayout(), animated: true)
            productCollectionView.visibleCells.forEach { cell in
                guard let cell = cell as? ProductCollectionViewCell else {
                    return
                }
                
                isSelected = true
                cell.accessories = [.delete()]
                cell.contentView.layer.borderColor = UIColor.black.cgColor
                cell.contentView.layer.borderWidth = 1
                
                cell.configureStackView(of: .vertical, textAlignment: .center)
            }
            
            productCollectionView.scrollToItem(at: IndexPath(item: -1, section: 0), at: .init(rawValue: 0), animated: false)
        default:
            break
        }
    }
    
    @objc func addTapped() {
        
    }
}
