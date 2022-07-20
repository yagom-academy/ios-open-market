//
//  OpenMarket - MarketProductsViewController.swift
//  Created by 데릭, 케이, 수꿍. 
//  Copyright © yagom. All rights reserved.
//

import UIKit

final class MarketProductsViewController: UIViewController {
    fileprivate enum Section {
        case main
    }
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["LIST", "GRID"])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var shouldHideListView: Bool? {
        didSet {
            guard let shouldHideListView = self.shouldHideListView else {
                return
            }
            
            self.listCollectionView?.isHidden = shouldHideListView
            self.gridCollectionView?.isHidden = !self.listCollectionView.isHidden
        }
    }
    
    private var products: [Product] = []
    private var productsModel: [ProductEntity] = []
    
    private var listCollectionView: UICollectionView!
    private var listDataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>!
    
    private var gridCollectionView: UICollectionView!
    private var gridDataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setNavigationItems()
        getData()
    }
}


private extension MarketProductsViewController {
    func getData() {
        let url = "https://market-training.yagom-academy.kr/api/products?page_no=1&items_per_page=50"
        
        let openMarket = NetworkProvider(session: URLSession.shared)
        openMarket.requestAndDecode(url: url, dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                self.products = productList.pages
                productList.pages.forEach { product in
                    let item = ProductEntity(thumbnailImage: product.thumbnailImage!, name: product.name, currency: product.currency, originalPrice: product.price, discountedPrice: product.bargainPrice, stock: product.stock)
                    self.productsModel.append(item)
                }
                
                DispatchQueue.main.async {
                    self.createGridCollectionView()
                    self.configureGridDataSource()
                    self.gridCollectionView.isHidden = true
                    self.createListCollectionView()
                    self.configureListDataSource()
                }
                
            case .failure(let error):
                self.presentConfirmAlert(message: error.errorDescription ?? "")
            }
        }
    }
    
    func presentConfirmAlert(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: false)
    }
    
    @objc func didSegmentedControlTapped(_ segment: UISegmentedControl) {
        self.shouldHideListView = segment.selectedSegmentIndex != 0
    }
    
    func setNavigationItems() {
        self.navigationItem.titleView = self.segmentedControl
        self.navigationItem.rightBarButtonItem  = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(addTapped))
        self.segmentedControl.addTarget(self, action: #selector(didSegmentedControlTapped(_:)), for: .valueChanged)
        self.segmentedControl.selectedSegmentIndex = 0
    }
    
    @objc func addTapped() {
        
    }
}

// MARK: Collection View
private extension MarketProductsViewController {
    func createListCollectionView() {
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
        view.addSubview(listCollectionView)
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            listCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            listCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            listCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.2))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionCell, ProductEntity> { (cell, indexPath, item) in
            cell.updateUI(item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, ProductEntity>(collectionView: listCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: ProductEntity) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
        
        applySnapShot(to: listDataSource)
    }
    
    func createGridCollectionView() {
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createGridLayout())
        
        view.addSubview(gridCollectionView)
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gridCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            gridCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func createGridLayout() -> UICollectionViewCompositionalLayout{
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(self.view.frame.height * 0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func configureGridDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<GridCollectionCell, ProductEntity> { cell, indexPath, item in
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.borderWidth = 1
            cell.layer.cornerRadius = 10
            
            cell.updateUI(item)
        }
        
        gridDataSource = UICollectionViewDiffableDataSource<Section, ProductEntity>(collectionView: gridCollectionView, cellProvider: { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        applySnapShot(to: gridDataSource)
    }
    
    func applySnapShot(to dataSource: UICollectionViewDiffableDataSource<Section, ProductEntity>) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ProductEntity>()
        snapShot.appendSections([.main])
        snapShot.appendItems(productsModel)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
}
