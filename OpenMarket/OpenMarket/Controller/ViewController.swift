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

        configureNavigationBar()
        configureProductCollectionView(type: .list)
        loadProductData(pageNumber: 1, itemsPerPage: 100)
    }
    
    func configureNavigationBar() {
        segmentControl.addTarget(self, action: #selector(switchView(_:)), for: .valueChanged)
        navigationItem.titleView = segmentControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(showProductRegistrationView))
    }
    
    func loadProductData(pageNumber: Int, itemsPerPage: Int) {
        networkManager.loadData(of: .productList(pageNumber: pageNumber, itemsPerPage: itemsPerPage),
                                dataType: ProductListData.self) { result in
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
            let groupSpacing = CGFloat(10)
            let itemSpacing = CGFloat(20)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalHeight(0.37))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitem: item,
                                                           count: 2)
            group.interItemSpacing = .fixed(itemSpacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = groupSpacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 0,
                                                            leading: 10,
                                                            bottom: 0,
                                                            trailing: 10)
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
        let listCellRegistration = createListCellRegistration()
        let gridCellRegistration = createGridCellRegistration()
        
        dataSource = UICollectionViewDiffableDataSource<Section, ProductData>(collectionView: productCollectionView) {
            collectionView, indexPath, product in
            if self.segmentControl.selectedSegmentIndex == 0 {
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration,
                                                                    for: indexPath,
                                                                    item: product)
            } else {
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegistration,
                                                                    for: indexPath,
                                                                    item: product)
            }
        }
        
        guard let product = productList?.pages else {
            return
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, ProductData>()
        snapshot.appendSections([.main])
        snapshot.appendItems(product)
        dataSource.apply(snapshot, animatingDifferences: false)
    }
    
    func createGridCellRegistration() -> UICollectionView.CellRegistration<GridCell, ProductData> {
        let gridCellRegistration = UICollectionView.CellRegistration<GridCell, ProductData> {
            cell, indexPath, product in
            cell.nameLabel.text = product.name
            if product.stock == .zero {
                cell.stockLabel.text = "품절"
                cell.stockLabel.textColor = .systemYellow
            } else {
                cell.stockLabel.text = "잔여수량: " + product.stock.description
                cell.stockLabel.textColor = .systemGray2
            }
            
            if product.price == product.bargainPrice {
                cell.priceLabel.text = product.currencyAndPrice
            } else {
                cell.priceLabel.attributedText = product.fetchCurrencyAndDiscountedPrice()
            }
            
            self.networkManager.loadThumbnailImage(of: product.thumbnail) { result  in
                switch result {
                case .success(let image):
                    DispatchQueue.main.async {
                        if indexPath == self.productCollectionView.indexPath(for: cell) {
                            cell.imageView.image = image
                        }
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        return gridCellRegistration
    }
    
    func createListCellRegistration() -> UICollectionView.CellRegistration<ListCell, ProductData> {
        let listCellRegistration = UICollectionView.CellRegistration<ListCell, ProductData> {
            cell, indexPath, product in
            var content = UIListContentConfiguration.cell()
            content.text = product.name
            content.textProperties.font = .preferredFont(forTextStyle: .headline)
            content.textProperties.adjustsFontForContentSizeCategory = true

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
                content.secondaryAttributedText = product.fetchCurrencyAndDiscountedPrice(" ")
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
        
        return listCellRegistration
    }
}

extension ViewController {
    @objc func showProductRegistrationView() {
        let viewController = ProductRegistrationViewController()
        
        present(viewController, animated: true, completion: nil)
    }
    
    @objc func switchView(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            productCollectionView.removeFromSuperview()
            configureProductCollectionView(type: .list)
            configureDataSource()
        } else {
            productCollectionView.removeFromSuperview()
            configureProductCollectionView(type: .grid)
            configureDataSource()
        }
    }
}
