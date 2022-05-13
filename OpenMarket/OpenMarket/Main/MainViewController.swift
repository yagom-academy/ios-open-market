//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright dudu, safari All rights reserved.
// 

import UIKit

private enum Section {
    case main
}

final class MainViewController: UIViewController {
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Product>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Product>
    
    private lazy var mainView = MainView(frame: self.view.bounds)
    private lazy var dataSource = makeDataSource()
    
    private var products = [Product]()
    
    private lazy var segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.addTarget(self, action: #selector(segmentValueDidChanged(segmentedControl:)), for: .valueChanged)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureNavigationBar()
        requestData()
    }
    
    private func configureView() {
        mainView.backgroundColor = .systemBackground
        self.view = mainView
        configureCollectionView()
    }
    
    private func configureNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonDidTapped))
        navigationItem.titleView = segmentControl
    }
    
    private func configureCollectionView() {
        mainView.collectionView.register(ProductGridCell.self, forCellWithReuseIdentifier: ProductGridCell.identifier)
        mainView.collectionView.register(ProductListCell.self, forCellWithReuseIdentifier: ProductListCell.identifier)
    }
    
    @objc private func addButtonDidTapped() {}
    
    @objc private func segmentValueDidChanged(segmentedControl: UISegmentedControl) {
        mainView.changeLayout(index: segmentedControl.selectedSegmentIndex)
        mainView.collectionView.reloadData()
    }
}

// MARK: - NetWork

extension MainViewController {
    private func requestData() {
        let endPoint = EndPoint.requestList(page: 1, itemsPerPage: 30)
        
        NetworkManager<ProductList>().request(endPoint: endPoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data.products else { return }
                self?.products = result
                self?.applySnapshot()
            case .failure(let error):
                print(error)
            }
        }
    }
}

//MARK: - CollectionView DataSource

extension MainViewController {
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(collectionView: mainView.collectionView) { [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let self = self else { return nil }
            
            guard let layout = CollectionLayout(rawValue: self.segmentControl.selectedSegmentIndex) else { return nil }
            
            switch layout {
            case .grid:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductGridCell.identifier, for: indexPath) as? ProductGridCell else { return ProductGridCell() }
                cell.configure(data: itemIdentifier)
                return cell
            case .list:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else { return ProductListCell() }
                cell.configure(data: itemIdentifier)
                return cell
            }
        }
        
        return dataSource
    }
    
    private func applySnapshot() {
        DispatchQueue.main.async { [self] in
            var snapshot = Snapshot()
            
            snapshot.appendSections([.main])
            snapshot.appendItems(products)
            dataSource.apply(snapshot)
        }
    }
}
