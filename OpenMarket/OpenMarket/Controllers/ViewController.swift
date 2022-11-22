//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

enum Section: Hashable {
    case main
}

class ViewController: UIViewController {
    
    let segmentedControl: UISegmentedControl = {
        let item = ["LIST", "GRID"]
        let segmentedControl = UISegmentedControl(items: item)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    private var gridCollectionView: UICollectionView!
    private var listCollectionView: UICollectionView!
    
    var itemList: [Item] = []
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    var listDataSource: UICollectionViewDiffableDataSource<Section, Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigation()
        configureFetchItemList()
        
    }
    @objc private func addItem() {
        print("button pressed.")
    }
    
    @objc private func changeItemView(_ sender: UISegmentedControl) {
        checkCollectionType(segmentIndex: sender.selectedSegmentIndex)
    }
    
    func checkCollectionType(segmentIndex: Int) {
        if segmentIndex == 0 {
            gridCollectionView.isHidden = true
            listCollectionView.isHidden = false
        } else {
            listCollectionView.isHidden = true
            gridCollectionView.isHidden = false
        }
    }
    func configureNavigation() {
        navigationItem.titleView = segmentedControl
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        segmentedControl.addTarget(self, action: #selector(changeItemView(_:)), for: .valueChanged)
    }
    
    func configureFetchItemList() {
        NetworkManager().fetchItemList(pageNo: 1, pageCount: 100) { result in
            switch result {
            case .success(let success):
                DispatchQueue.main.async {
                    self.itemList = success.pages
                    self.configureCollectionView()
                    self.configureListDataSource()
                    self.configureGridDataSource()
                }
            case .failure(let failure):
                print(failure)
            }
        }
    }
}

extension ViewController {
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func createGridLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        let spacing = CGFloat(10)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = spacing
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureCollectionView() {
        listCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createListLayout())
        gridCollectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createGridLayout())
        view.addSubview(listCollectionView)
        view.addSubview(gridCollectionView)
        
        checkCollectionType(segmentIndex: segmentedControl.selectedSegmentIndex)
    }
    
    private func configureGridDataSource() {
        let cellRegisteration = UICollectionView.CellRegistration<GridCollectionViewCell, Item> { cell, indexPath, item in
            cell.configureData(item: item)
        }
        gridDataSource = UICollectionViewDiffableDataSource(collectionView: gridCollectionView,
                                                        cellProvider: { collectionView, indexPath, item in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegisteration, for: indexPath, item: item)
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemList)
        self.gridDataSource.apply(snapshot, animatingDifferences: false)
    }
    
    private func configureListDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<ListCollectionViewCell, Item> { (cell, indexPath, item) in
            cell.updateWithItem(item)
            cell.accessories = [.disclosureIndicator()]
        }
        
        listDataSource = UICollectionViewDiffableDataSource<Section, Item>(collectionView: listCollectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, item: Item) -> UICollectionViewCell? in
            
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(itemList)
        listDataSource.apply(snapshot, animatingDifferences: false)
    }
}
