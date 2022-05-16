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
    private var pageNumber = 1
    
    private var networkManager = NetworkManager<ProductList>(imageCache: CacheManager())
    
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
        requestData(pageNumber: pageNumber)
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
        mainView.collectionView.prefetchDataSource = self
    }
    
    @objc private func addButtonDidTapped() {}
    
    @objc private func segmentValueDidChanged(segmentedControl: UISegmentedControl) {
        mainView.changeLayout(index: segmentedControl.selectedSegmentIndex)
        mainView.collectionView.reloadData()
    }
}

// MARK: - NetWork

extension MainViewController {
    private func requestData(pageNumber: Int) {
        let endPoint = EndPoint.requestList(page: pageNumber, itemsPerPage: 20, httpMethod: .get)
        
        networkManager.request(endPoint: endPoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data.products else { return }
                self?.products.append(contentsOf: result)
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
                self.networkManager.downloadImage(urlString: itemIdentifier.thumbnail) { result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            guard collectionView.indexPath(for: cell) == indexPath else { return }
                            cell.setImage(with: image)
                        }
                    case .failure(_):
                        break
                    }
                }
                return cell
            case .list:
                guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductListCell.identifier, for: indexPath) as? ProductListCell else { return ProductListCell() }
                cell.configure(data: itemIdentifier)
                self.networkManager.downloadImage(urlString: itemIdentifier.thumbnail) { result in
                    switch result {
                    case .success(let image):
                        DispatchQueue.main.async {
                            guard collectionView.indexPath(for: cell) == indexPath else { return }
                            cell.setImage(with: image)
                        }
                    case .failure(_):
                        break
                    }
                }
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

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let indexPath = indexPaths.last else { return }
        let section = indexPath.row / 20
        
        if section + 1 == pageNumber {
            pageNumber += 1
            requestData(pageNumber: pageNumber)
        }
    }
}
