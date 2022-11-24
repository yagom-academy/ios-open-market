//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    enum Section {
        case main
    }
    
    let formatter: NumberFormatter = {
        let formmater = NumberFormatter()
        formmater.numberStyle = .decimal
        
        return formmater
    }()
    
    lazy var navSegmentedView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBlue
        for index in 0..<segmentedControl.numberOfSegments {
            segmentedControl.setWidth(view.frame.width / 5, forSegmentAt: index)
        }
        
        return segmentedControl
    }()
    
    var listCellRegistration: UICollectionView.CellRegistration<ListCell, Product>!
    var gridCellRegistration: UICollectionView.CellRegistration<GridCell, Product>!
    
    var collectionView: UICollectionView!
    var listDataSource: UICollectionViewDiffableDataSource<Section, Product>!
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Product>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        setCellRegistration()
        configure()
        print("1")

        let manager = NetworkManager()
        
        manager.getProductsList(pageNo: 1, itemsPerPage: 30) { [self] list in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(list.products)
            self.gridDataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                
                return collectionView.dequeueConfiguredReusableCell(using: self.gridCellRegistration, for: indexPath, item: itemIdentifier)
            })
            
            self.listDataSource = UICollectionViewDiffableDataSource(collectionView: self.collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
                return collectionView.dequeueConfiguredReusableCell(using: self.listCellRegistration, for: indexPath, item: itemIdentifier)
            })
            
            print("2")
            
            self.gridDataSource.apply(snapshot)
            self.listDataSource.apply(snapshot)
        }
        
        setupNavBar()
    }
    
    private func setCellRegistration() {
        self.listCellRegistration = UICollectionView.CellRegistration<ListCell, Product> { cell, indexPath, itemIdentifier in
            self.cellRegistration(cell, indexPath, itemIdentifier)
        }
        
        self.gridCellRegistration = UICollectionView.CellRegistration<GridCell, Product> { cell, indexPath, itemIdentifier in
            DispatchQueue.global().async {
                if itemIdentifier.hashValue != indexPath.hashValue {
                    guard let url = URL(string: itemIdentifier.thumbnail),
                          let data = try? Data(contentsOf: url)  else {
                        return
                    }
                    
                    let picture = UIImage(data: data)
                    
                    DispatchQueue.main.async {
                        cell.productName.text = "\(itemIdentifier.name)"
                        cell.bargainPrice.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.bargainPrice) ?? "")"
                        cell.image.image = picture
                        
                        if itemIdentifier.bargainPrice != itemIdentifier.price {
                            cell.price.text = "\(itemIdentifier.currency.rawValue) \(itemIdentifier.price)"
                        } else {
                            cell.price.isHidden = true
                        }
                        
                        if itemIdentifier.stock == 0 {
                            cell.stock.text = "품절"
                            cell.stock.textColor = .systemYellow
                        } else {
                            cell.stock.text = "잔여수량 : \(itemIdentifier.stock)"
                        }
                    }
                }
            }
        }
        print("?")
    }

    private func cellRegistration(_ cell: ListCell, _ indexPath: IndexPath, _ itemIdentifier: Product) {
        DispatchQueue.global().async {
            if itemIdentifier.hashValue != indexPath.hashValue {
                guard let url = URL(string: itemIdentifier.thumbnail),
                      let data = try? Data(contentsOf: url)  else {
                    return
                }
                
                let picture = UIImage(data: data)
                
                DispatchQueue.main.async {
                    cell.productName.text = "\(itemIdentifier.name)"
                    cell.bargainPrice.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.bargainPrice) ?? "")"
                    cell.image.image = picture
                    
                    if itemIdentifier.bargainPrice != itemIdentifier.price {
                        cell.price.text = "\(itemIdentifier.currency.rawValue) \(itemIdentifier.price)"
                    } else {
                        cell.price.isHidden = true
                    }
                    
                    if itemIdentifier.stock == 0 {
                        cell.stock.text = "품절"
                        cell.stock.textColor = .systemYellow
                    } else {
                        cell.stock.text = "잔여수량 : \(itemIdentifier.stock)"
                    }
                }
            }
        }
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(10))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createCollectionView() {
        let layout = createListLayout()
        
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(collectionView)
    }
    
    private func configure() {
        self.view.backgroundColor = .systemBackground
        self.navSegmentedView.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    func setupNavBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .systemGray6
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        
        self.navigationController?.navigationBar.backgroundColor = .systemGray
        
        self.navigationItem.titleView = navSegmentedView
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tappedAddButton))
    }
}

// MARK: - Obj-C Method
extension ViewController {
    @objc func tappedAddButton() {
        
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch self.navSegmentedView.selectedSegmentIndex {
        case 0:
            print("sss")
            let layout = createListLayout()
            collectionView.dataSource = listDataSource
            collectionView.setCollectionViewLayout(layout, animated: true)
        case 1:
            let layout = createGridLayout()
            collectionView.dataSource = gridDataSource
            collectionView.setCollectionViewLayout(layout, animated: true)
        default:
            return
        }
    }
}
