//
//  OpenMarket - OpenMarketViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class OpenMarketViewController: UIViewController {
    
    private enum ProductListSection: Int {
        case main
    }
    
    private enum ViewType: Int {
        case list
        case grid
        
        var typeName: String {
            switch self {
            case .list:
                return "LIST"
            case .grid:
                return "GRID"
            }
        }
    }
    
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [ViewType.list.typeName, ViewType.grid.typeName])
            control.translatesAutoresizingMaskIntoConstraints = false
            return control
    }()
    
    private var gridCollectionView: UICollectionView?
    private var listCollectionView: UICollectionView?
    private var dataSource: UICollectionViewDiffableDataSource<ProductListSection, Product>?
    private var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async {
                self.applySnapshot(for: self.products)
            }
        }
    }
    
    private var pageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        navigationItem.titleView = segmentedControl
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        navigationItem.standardAppearance = appearance
        
        segmentedControl.addTarget(self, action: #selector(self.segmentValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = ViewType.list.rawValue
        segmentValueChanged(segmentedControl)

        
        // fetchData가 끝나면 실행되도록 변경해주면 될듯????
        configureListCollectionView()
        configureListDataSource()
        
        fetchData(for: pageNumber)
    }
    
    @objc func segmentValueChanged(_ sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case ViewType.list.rawValue:
            configureListCollectionView()
            configureListDataSource()
            applySnapshot(for: products)
            listCollectionView?.isHidden = false
            gridCollectionView?.isHidden = true
        case ViewType.grid.rawValue:
            configureGridCollectionView()
            configureGridDataSource()
            applySnapshot(for: products)
            gridCollectionView?.isHidden = false
            listCollectionView?.isHidden = true
        default:
            configureListCollectionView()
            configureListDataSource()
            applySnapshot(for: products)
            listCollectionView?.isHidden = false
            gridCollectionView?.isHidden = true
        }
    }
    
//    var isLoading: Bool = false
    
    func fetchData(for page: Int) {
//        guard !isLoading else { return }
        let networkManager = NetworkManager()
//        isLoading = true
        networkManager.request(endpoint: OpenMarketAPI.productList(pageNumber: page, itemsPerPage: 10), dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                var refinedProducts: [Product] = []
                for product in productList.products {
                    if self.products.contains(product) { continue }
                    refinedProducts.append(product)
                }
                self.products += refinedProducts
//                self.isLoading = false
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureGridCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let gridCollectionView = gridCollectionView else { return }
        view.addSubview(gridCollectionView)
        
        gridCollectionView.delegate = self
        
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gridCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    func configureGridDataSource() {
        guard let gridCollectionView = gridCollectionView else { return }

        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product>(collectionView: gridCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell
            cell?.contentView.backgroundColor = .white
            cell?.contentView.layer.borderColor = UIColor.gray.cgColor
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.cornerRadius = 10.0
            cell?.contentView.layer.masksToBounds = true
            cell?.updateContents(product)
            return cell
        }
    }
    
    private func configureListCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let listCollectionView = listCollectionView else { return }
        
        view.addSubview(listCollectionView)
        
        listCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            listCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            listCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            listCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            listCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func configureListDataSource() {
        guard let listCollectionView = listCollectionView else { return }
        
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Product> { (cell, indexPath, product) in
            cell.updateContents(product)
        }
        
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product>(collectionView: listCollectionView) { (colllectionView: UICollectionView, indexPath: IndexPath, identifier: Product) -> UICollectionViewCell? in
            
            return listCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
//        listCollectionView.register(ListCollectionViewCell.self, forCellWithReuseIdentifier: ListCollectionViewCell.identifier)
//
//        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product>(collectionView: listCollectionView) { (collectionView, indexPath, product) -> UICollectionViewCell? in
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ListCollectionViewCell.identifier, for: indexPath) as? ListCollectionViewCell
//            cell?.updateContents(product)
//
//            return cell
//        }
    }
    
    func applySnapshot(for items: [Product]) {
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, Product>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
}

extension OpenMarketViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == products.count - 1 {
            pageNumber += 1
            fetchData(for: pageNumber)
        }
    }
}

extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = collectionView.frame.width / 2 - 15
        let height: CGFloat = collectionView.frame.height / 3 - 20
        return CGSize(width: width, height: height)
    }
}
