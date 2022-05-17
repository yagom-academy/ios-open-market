//
//  OpenMarket - MainViewController.swift
//  Created by yagom. 
//  Copyright dudu, safari All rights reserved.
// 

import UIKit

private enum Section {
    case main
}

private enum Constant {
    static let requestItemCount = 20
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
        
        segmentControl.setTitleTextAttributes([.foregroundColor : UIColor.white], for: .selected)
        segmentControl.setTitleTextAttributes([.foregroundColor : UIColor.systemBlue], for: .normal)
        segmentControl.selectedSegmentTintColor = .systemBlue
        segmentControl.setWidth(view.bounds.width / 5, forSegmentAt: 0)
        segmentControl.setWidth(view.bounds.width / 5, forSegmentAt: 1)
        segmentControl.layer.borderWidth = 1.0
        segmentControl.layer.borderColor = UIColor.systemBlue.cgColor
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
}

// MARK: - Action Method

extension MainViewController {
    @objc private func addButtonDidTapped() {}
    
    @objc private func segmentValueDidChanged(segmentedControl: UISegmentedControl) {
        mainView.changeLayout(index: segmentedControl.selectedSegmentIndex)
        mainView.collectionView.reloadData()
    }
}

// MARK: - NetWork Method

extension MainViewController {
    private func requestData(pageNumber: Int) {
        let endPoint = EndPoint.requestList(page: pageNumber, itemsPerPage: Constant.requestItemCount, httpMethod: .get)
        
        networkManager.request(endPoint: endPoint) { [weak self] result in
            switch result {
            case .success(let data):
                guard let result = data.products else { return }
                
                self?.products.append(contentsOf: result)
                self?.applySnapshot()
                
                DispatchQueue.main.async {
                    self?.mainView.indicatorView.stopAnimating()
                }
            case .failure(_):
                break
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
            let cellType = layout.cellType
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.identifier, for: indexPath) as? ProductCell else { return cellType.init() }
            
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

//MARK: - CollectionView DataSourcePrefetching

extension MainViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        prefetchData(indexPaths)
    }
    
    private func prefetchData(_ indexPaths: [IndexPath]) {
        guard let indexPath = indexPaths.last else { return }
        
        let section = indexPath.row / Constant.requestItemCount
        
        if section + 1 == pageNumber {
            pageNumber += 1
            requestData(pageNumber: pageNumber)
        }
    }
}
