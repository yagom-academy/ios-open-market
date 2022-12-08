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
            
    private var segmentedControl: UISegmentedControl?
    
    private var productRegisterView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let activityIndicator = UIActivityIndicatorView()
    
    private var dataSource: UICollectionViewDiffableDataSource<ProductListSection, Product.ID>?
    private var products: [Product] = []
    
    private let networkManager = NetworkManager()
    
    private var pageNumber: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureSegmentedControl()
    
        fetchData(for: pageNumber)
        
        configureListCollectionView()
        configureListDataSource()
        
        configureActivityIndicator()
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(registerProduct(_:)))
    }
    
    private func configureSegmentedControl() {
        segmentedControl = UISegmentedControl(items: [])
        
        guard let segmentedControl = segmentedControl else { return }
        
        addSegment(with: ViewType.list.typeName, at: segmentedControl.numberOfSegments)
        addSegment(with: ViewType.grid.typeName, at: segmentedControl.numberOfSegments)
        
        segmentedControl.addTarget(self, action: #selector(self.segmentValueChanged(_:)), for: .valueChanged)
        
        segmentedControl.selectedSegmentIndex = ViewType.list.rawValue
        segmentValueChanged(segmentedControl)
        
        navigationItem.titleView = segmentedControl
    }

    private func addSegment(with title: String?, at index: Int) {
        segmentedControl?.insertSegment(withTitle: title, at: index, animated: false)
    }
    
    @objc private func segmentValueChanged(_ sender: UISegmentedControl) {
        guard let viewType: ViewType = ViewType(rawValue: sender.selectedSegmentIndex) else { return }

        switch viewType {
        case ViewType.list:
            if listCollectionView == nil {
                configureListCollectionView()
                configureListDataSource()
            }
            applySnapshot(for: products)
            listCollectionView?.isHidden = false
            gridCollectionView?.isHidden = true
        case ViewType.grid:
            if gridCollectionView == nil {
                configureGridCollectionView()
                configureGridDataSource()
            }
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
        activityIndicator.style = .large
        activityIndicator.center = view.center
    }

    private func fetchData(for page: Int) {
        activityIndicator.startAnimating()
        
        networkManager.request(endpoint: OpenMarketAPI.productList(pageNumber: page, itemsPerPage: 20), dataType: ProductList.self) { result in
            switch result {
            case .success(let productList):
                var refinedProducts: [Product] = []
                for product in productList.products {
                    if self.products.contains(product) { continue }
                    refinedProducts.append(product)
                }
                self.products += refinedProducts
                DispatchQueue.main.async {
                    self.applySnapshot(for: self.products)
                    self.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                self.showDataRequestFailureAlert(error)
            }
        }
    }
    
    private func showDataRequestFailureAlert(_ error: NetworkError) {
        let alert = UIAlertController(title: AlertConstants.alertTitle.rawValue, message: error.rawValue, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertConstants.actionTitle.rawValue, style: .default))
        
        self.present(alert, animated: true)
    }
    
    private func configureListCollectionView() {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: LayoutConstants.listCellContentInset.value,
                                                     leading: LayoutConstants.listCellContentInset.value,
                                                     bottom: LayoutConstants.listCellContentInset.value,
                                                     trailing: LayoutConstants.listCellContentInset.value)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.07))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let listCollectionView = listCollectionView else { return }
        
        configureCollectionView(listCollectionView)
    }
    
    private func configureListDataSource() {
        guard let listCollectionView = listCollectionView else { return }
        
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Product> { (cell, indexPath, product) in
            cell.updateContents(product)
            cell.updateImage(product)
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
        layout.minimumLineSpacing = LayoutConstants.gridCellMinimumLineSpacing.value
        layout.minimumInteritemSpacing = LayoutConstants.gridCellMinimumInteritemSpacing.value
        layout.sectionInset = UIEdgeInsets(top: LayoutConstants.gridCellSectionInset.value,
                                           left: LayoutConstants.gridCellSectionInset.value,
                                           bottom: LayoutConstants.gridCellSectionInset.value,
                                           right: LayoutConstants.gridCellSectionInset.value)
        gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        guard let gridCollectionView = gridCollectionView else { return }
    
        configureCollectionView(gridCollectionView)
    }
    
    private func configureCollectionView(_ collectionView: UICollectionView) {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor)
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
            
            guard let product else { return UICollectionViewCell() }
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GridCollectionViewCell.identifier, for: indexPath) as? GridCollectionViewCell
            cell?.product = product
            cell?.updateContents(product)
            cell?.updateImage(product)
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
        let width: CGFloat = (collectionView.frame.width / LayoutConstants.gridPerRow.value) - (LayoutConstants.gridCellMinimumInteritemSpacing.value * (LayoutConstants.gridPerRow.value + 1))
        let height: CGFloat = (collectionView.frame.height / LayoutConstants.gridPerCol.value) - (LayoutConstants.gridCellMinimumInteritemSpacing.value * (LayoutConstants.gridPerCol.value + 1))
        return CGSize(width: width, height: height)
    }
}
