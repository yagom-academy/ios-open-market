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
        setUpCollectionView()
    }
    
    private func setUpCollectionView() {
        mainView.collectionView.register(
            ListCollectionViewCell.self,
            forCellWithReuseIdentifier: "ListCollectionViewCell"
        )
        mainView.collectionView.register(
            GridCollectionViewCell.self,
            forCellWithReuseIdentifier: "GridCollectionViewCell"
        )
    }
    
    private func makeDataSource() -> DataSource {
        let dataSource = DataSource(
            collectionView: mainView.collectionView,
            cellProvider: { (collectionView, indexPath, item) ->
                UICollectionViewCell in
                switch self.mainView.layoutStatus {
                case .list:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "ListCollectionViewCell",
                        for: indexPath) as? ListCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.updateUI(data: item, image: UIImage(systemName: "swift"))
                    return cell
                case .grid:
                    guard let cell = collectionView.dequeueReusableCell(
                        withReuseIdentifier: "GridCollectionViewCell",
                        for: indexPath) as? GridCollectionViewCell else {
                        return UICollectionViewCell()
                    }
                    cell.updateUI(data: item, image: UIImage(systemName: "swift"))
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

