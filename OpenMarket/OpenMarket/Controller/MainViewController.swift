//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    enum Section {
        case main
    }
    var cacheProducts: [Product]?
    var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var currentSnapshot: NSDiffableDataSourceSnapshot<Section, Product>! = nil
    lazy var baseView = BaseView(frame: view.bounds)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = baseView
        setUpNavigationItem()
        
        fetchData(layout: createListLayout)
    }
    
    func fetchData(layout: @escaping () -> UICollectionViewLayout) {
        HTTPManager().loadData(targetURL: .productList(pageNumber: 1, itemsPerPage: 20)) { [self] data in
            switch data {
            case .success(let data):
                guard let products = try? JSONDecoder().decode(OpenMarketProductList.self, from: data).products else { return }
                DispatchQueue.main.async { [self] in
                    self.configureHierarchy(createLayout: layout)
                    self.configureDataSource()
                    updateSnapshot(products: products)
                    cacheProducts = products
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func setUpNavigationItem() {
        setUpSegmentation()
        navigationItem.titleView = baseView.segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(registerProduct))
    }
    
    func setUpSegmentation() {
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18 , forSegmentAt: 0)
        baseView.segmentedControl.setWidth(view.bounds.width * 0.18, forSegmentAt: 1)
        baseView.segmentedControl.addTarget(self, action: #selector(switchCollectionViewLayout), for: .valueChanged)
    }
    
    @objc func switchCollectionViewLayout() {
        self.configureDataSource()
        dataSource.apply(currentSnapshot)
    }
    
    @objc func registerProduct() {
    }
}

extension MainViewController {
    
    func configureHierarchy(createLayout: () -> UICollectionViewLayout) {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.addSubview(collectionView)
        layoutCollectionView()
    }
    
    func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        section.interGroupSpacing = 5
        group.interItemSpacing = .fixed(10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func createListLayout() -> UICollectionViewLayout {
        let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    func layoutCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureDataSource() {
        let listCellRegisteration = UICollectionView.CellRegistration<ProductListCell, Product> { (cell, indexPath, item) in
            
            guard let currentSnapshot = self.currentSnapshot else {return}
            
            let sectionIdentifier = currentSnapshot.sectionIdentifiers[indexPath.section]
            let numberOfItemsInSection = currentSnapshot.numberOfItems(inSection: sectionIdentifier)
            let isLastCell = indexPath.item + 1 == numberOfItemsInSection
            cell.seperatorView.isHidden = isLastCell
            
            cell.updateWithItem(item)
        }
        let gridCellRegisteration = UICollectionView.CellRegistration<ProductGridCell, Product> { (cell, indexPath, item) in
            cell.updateWithItem(item)
        }
        
        if baseView.segmentedControl.selectedSegmentIndex == 0 {
            dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegisteration, for: indexPath, item: itemIdentifier) }
            
        } else {
            dataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView) { (collectionView, indexPath, itemIdentifier) -> UICollectionViewCell? in
                return collectionView.dequeueConfiguredReusableCell(using: gridCellRegisteration, for: indexPath, item: itemIdentifier) }
        }
        
    }
    
    func updateSnapshot(products: [Product]) {
        currentSnapshot = dataSource.snapshot()
        currentSnapshot.appendSections([.main])
        currentSnapshot.appendItems(products)
        dataSource.apply(currentSnapshot)
        
    }
}
