//
//  OpenMarket - ItemListPageViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

final class ItemListPageViewController: UIViewController {
    
    // MARK: - Properties

    private var itemListPage: ItemListPage?
    private var snapshot: NSDiffableDataSourceSnapshot<Section, ItemListPage.Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ItemListPage.Item>()

        snapshot.appendSections([.main])
        snapshot.appendItems(itemListPage!.items)
        
        return snapshot
    }
    
    private lazy var request = Path.products + queryString
    private let queryString = QueryCharacter.questionMark + QueryKey.pageNumber + QueryValue.pageNumber + QueryCharacter.ampersand + QueryKey.itemsPerPage + QueryValue.itemsPerPage
    
    private var collectionViewDiffableDataSource: UICollectionViewDiffableDataSource<Section, ItemListPage.Item>!
    
    // MARK: - UI Components
    
    private var itemCollectionView: UICollectionView!
    private let segmentedControl: UISegmentedControl = {
        let selectionItems = [
            UIImage(systemName: "rectangle.grid.1x2"),
            UIImage(systemName: "square.grid.2x2")
        ]
        
        let segmentedControl = UISegmentedControl(items: selectionItems as [Any])
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        return segmentedControl
    }()
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager.performRequestToAPI(from: HostAPI.openMarket.url, with: request) { (result: Result<Data, NetworkingError>) in
            self.fetchParsedData(basedOn: result)
        }
        
        setUpSegmentedControlWithLayout()
        setUpItemCollectionViewWithLayout()
        
        itemCollectionView.register(ItemListCollectionViewCell.self, forCellWithReuseIdentifier: "itemCell")
        
        configureCollectionViewDiffableDataSource()
        touchUpSegmentedControl()
    }
}

// MARK: - Private Actions for SegmentedControl

private extension ItemListPageViewController {
    func setUpSegmentedControlWithLayout() {
        self.view.addSubview(segmentedControl)
        
        segmentedControl.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 8.0).isActive = true
        segmentedControl.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
        segmentedControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    
    func touchUpSegmentedControl() {
        segmentedControl.addTarget(self, action: #selector(selectLayout), for: .valueChanged)
    }
    
    @objc func selectLayout(segmentedControl: UISegmentedControl) {
        if segmentedControl.selectedSegmentIndex == 0 {
            itemCollectionView.collectionViewLayout = generateCompositionalLayout(numberOfItemsAtRow: 1)
        } else {
            itemCollectionView.collectionViewLayout = generateCompositionalLayout(numberOfItemsAtRow: 2)
        }
    }
}
    func fetchParsedData(basedOn result: Result<Data, NetworkingError>) {
        switch result {
        case .success(let data):
            itemListPage = NetworkManager.parse(data, into: ItemListPage.self)
            
            collectionViewDiffableDataSource.apply(self.snapshot, animatingDifferences: true)
            
        case .failure(let error):
            print(error)
        }
    }
}

// MARK: - Private Actions for Collection View UI

private extension ItemListPageViewController {
    func setUpItemCollectionViewWithLayout() {
        itemCollectionView = UICollectionView(frame: .zero, collectionViewLayout: generateCompositionalLayout(numberOfItemsAtRow: 1))
        
        view.addSubview(itemCollectionView)
        
        itemCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            itemCollectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 16.0),
            itemCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16.0),
            itemCollectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8.0),
            itemCollectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8.0)
        ])
    }
    
    func generateCompositionalLayout(numberOfItemsAtRow: Int) -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(100.0)
        )
        
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: numberOfItemsAtRow
        )
        
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

// MARK: - Private Actions for Collection View Model

private extension ItemListPageViewController {
    func configureCollectionViewDiffableDataSource() {
        
        collectionViewDiffableDataSource = .init(collectionView: self.itemCollectionView, cellProvider: { (collectionView, indexPath, itemListPageData) -> UICollectionViewCell? in
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemListCollectionViewCell
            
            cell.receiveData(itemListPageData)
            
            return cell
        })
    }
}

// MARK: - Private Enums

private extension ItemListPageViewController {
    enum QueryValue {
        static var pageNumber = "1"
        static var itemsPerPage = "10"
    }
    
    enum QueryKey {
        static var pageNumber = "page_no="
        static var itemsPerPage = "items_per_page="
    }
    
    enum Path {
        static var products = "/api/products"
    }
    
    enum QueryCharacter {
        static var questionMark = "?"
        static var ampersand = "&"
    }
    
    enum Section: CaseIterable {
        case main
    }
}
