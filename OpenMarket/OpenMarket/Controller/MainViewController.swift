//
//  OpenMarket - MainViewController.swift
//  Created by Red, Mino.
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class MainViewController: UIViewController {
    enum Section {
        case main
    }
    
    private lazy var mainView = MainView(frame: view.bounds)
    private let productsAPIServie = APIProvider<Products>()
    private typealias DataSource = UICollectionViewDiffableDataSource<Section, Item>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Item>
    private lazy var datasource = makeDataSource()
    
    private var items: [Item] = []
    
    override func loadView() {
        super.loadView()
        view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationItem()
        setUpCollectionView()
        setUpSegmentControl()
        requestProducts()
    }
    
    private func setUpNavigationItem() {
        navigationItem.titleView = mainView.segmentControl
        navigationItem.rightBarButtonItem = mainView.addButton
    }
    
    private func setUpCollectionView() {
        mainView.collectionView.register(
            ListCollectionViewCell.self,
            forCellWithReuseIdentifier: ListCollectionViewCell.identifier
        )
        mainView.collectionView.register(
            GridCollectionViewCell.self,
            forCellWithReuseIdentifier: GridCollectionViewCell.identifier
        )
    }
    
    private func setUpSegmentControl() {
        mainView.segmentControl.addTarget(self, action: #selector(changeLayout), for: .valueChanged)
    }
    
    @objc private func changeLayout() {
        mainView.setUpLayout(segmentIndex: mainView.segmentControl.selectedSegmentIndex)
    }
    
    private func requestProducts() {
        let endpoint = EndPointStorage.productsList(pageNumber: 1, perPages: 100)
        
        productsAPIServie.request(with: endpoint) { result in
            switch result {
            case .success(let products):
                self.items.append(contentsOf: products.items)
                self.applySnapshot(animatingDifferences: false)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: mainView.collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell in
                switch self.mainView.layoutStatus {
                case .list:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: ListCollectionViewCell.identifier,
                        for: indexPath) as? ListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
    
                    self.productsAPIServie.requestImage(with: item.thumbnail) { result in
                        switch result {
                        case .success(let image):
                            DispatchQueue.main.async {
                                if collectionView.indexPath(for: cell) == indexPath {
                                    cell.updateImage(image: image)
                                }
                            }
                        case .failure(_):
                            print("썸네일 에러")
                        }
                    }
                    
                    cell.updateLabel(data: item)
                    return cell
                
                case .grid:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: GridCollectionViewCell.identifier,
                        for: indexPath) as? GridCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    
                    self.productsAPIServie.requestImage(with: item.thumbnail) { result in
                        switch result {
                        case .success(let image):
                            DispatchQueue.main.async {
                                if collectionView.indexPath(for: cell) == indexPath {
                                    cell.updateImage(image: image)
                                }
                            }
                        case .failure(_):
                            print("썸네일 에러")
                        }
                    }
                    
                    cell.updateLabel(data: item)
                    return cell
                }
            })
        return dataSource
    }
    
    private func applySnapshot(animatingDifferences: Bool = true) {
        DispatchQueue.main.async {
            var snapshot = Snapshot()
            snapshot.appendSections([.main])
            snapshot.appendItems(self.items, toSection: .main)
            self.datasource.apply(snapshot, animatingDifferences: animatingDifferences)
        }
    }
}

