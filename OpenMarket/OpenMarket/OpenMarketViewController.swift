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
    
    private var gridCollectionView: UICollectionView?
    private var listCollectionView: UICollectionView?
            
    private let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: [ViewType.list.typeName, ViewType.grid.typeName])
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private var productRegisterView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var dataSource: UICollectionViewDiffableDataSource<ProductListSection, Product.ID>?
    private var products: [Product] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.applySnapshot(for: self?.products)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
    
    private var pageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
    
        fetchData(for: pageNumber)
        
        configureListCollectionView()
        configureListDataSource()
        
        configureActivityIndicator()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        navigationItem.titleView = segmentedControl
        segmentedControl.addTarget(self, action: #selector(self.segmentValueChanged(_:)), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = ViewType.list.rawValue
        segmentValueChanged(segmentedControl)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(registerProduct(_:)))
    }
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        guard let viewType: ViewType = ViewType(rawValue: sender.selectedSegmentIndex) else { return }

        switch viewType {
        case ViewType.list:
            configureListCollectionView()
            configureListDataSource()
            applySnapshot(for: products)
            listCollectionView?.isHidden = false
            gridCollectionView?.isHidden = true
        case ViewType.grid:
            configureGridCollectionView()
            configureGridDataSource()
            applySnapshot(for: products)
            gridCollectionView?.isHidden = false
            listCollectionView?.isHidden = true
        }
    }
    
    @objc private func registerProduct(_ sender: UIBarButtonItem) {
        view.addSubview(productRegisterView)
        
        NSLayoutConstraint.activate([
            productRegisterView.topAnchor.constraint(equalTo: view.topAnchor),
            productRegisterView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            productRegisterView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productRegisterView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        activityIndicator.center = view.center
    }

    private func fetchData(for page: Int) {
        activityIndicator.startAnimating()
        
        let networkManager = NetworkManager()
        networkManager.request(endpoint: OpenMarketAPI.productList(pageNumber: page, itemsPerPage: 20), dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                var refinedProducts: [Product] = []
                for product in productList.products {
                    if self.products.contains(product) { continue }
                    refinedProducts.append(product)
                }
                self.products += refinedProducts
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureListCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.07))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let listCollectionView = listCollectionView else { return }
        
        view.addSubview(listCollectionView)
        listCollectionView.delegate = self
        listCollectionView.backgroundColor = .systemBackground
        
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
        
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product.ID>(collectionView: listCollectionView) { colllectionView, indexPath, identifier -> UICollectionViewCell? in
            
            var product: Product?
            self.products.forEach {
                if $0.id == identifier { product = $0 }
            }
            let cell = listCollectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: product)
            cell.product = product
            
            return cell
        }
    }
    
    private func applySnapshot(for items: [Product]?) {
        var itemIdentifiers: [Product.ID] = []
        products.forEach {
            itemIdentifiers.append($0.id)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<ProductListSection, Product.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemIdentifiers, toSection: .main)
        dataSource?.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureGridCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 5
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let gridCollectionView = gridCollectionView else { return }
        view.addSubview(gridCollectionView)
        
        gridCollectionView.delegate = self
        gridCollectionView.backgroundColor = .systemBackground
        
        gridCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            gridCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            gridCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            gridCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            gridCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }
    
    private func configureGridDataSource() {
        guard let gridCollectionView = gridCollectionView else { return }
        
        gridCollectionView.register(GridCollectionViewCell.self, forCellWithReuseIdentifier: GridCollectionViewCell.identifier)
        
        dataSource = UICollectionViewDiffableDataSource<ProductListSection, Product.ID>(collectionView: gridCollectionView) { collectionView, indexPath, identifier -> UICollectionViewCell? in
            
            var product: Product?
            self.products.forEach {
                if $0.id == identifier { product = $0 }
            }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell
            cell?.contentView.backgroundColor = .systemBackground
            cell?.contentView.layer.borderColor = UIColor.gray.cgColor
            cell?.contentView.layer.borderWidth = 1.0
            cell?.contentView.layer.cornerRadius = 10.0
            cell?.contentView.layer.masksToBounds = true
            cell?.product = product
            cell?.updateContents(product)
            return cell
        }
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
