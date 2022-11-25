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
    
    var listCellRegistration: UICollectionView.CellRegistration<ListCell, Product>?
    var gridCellRegistration: UICollectionView.CellRegistration<GridCell, Product>?
    var listDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    var gridDataSource: UICollectionViewDiffableDataSource<Section, Product>?
    
    lazy var collectionView: UICollectionView = {
        let layout = createListLayout()
        
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        return indicator
    }()
    
    let manager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        configureListCell()
        configureGridCell()
        setUpUI()
        loadProductListToCollectionView()
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
    
    private func configureListCell() {
        self.listCellRegistration = UICollectionView.CellRegistration<ListCell, Product> { cell, indexPath, itemIdentifier in
            DispatchQueue.global().async {
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
                        cell.price.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.price) ?? "")"
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
        
        self.listDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            guard let listCell = self.listCellRegistration else {
                return UICollectionViewCell()
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: listCell, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func configureGridCell() {
        self.gridCellRegistration = UICollectionView.CellRegistration<GridCell, Product> { cell, indexPath, itemIdentifier in
            DispatchQueue.global().async {
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
                        cell.price.text = "\(itemIdentifier.currency.rawValue) \(self.formatter.string(for: itemIdentifier.price) ?? "") "
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
        
        self.gridDataSource = UICollectionViewDiffableDataSource<Section, Product>(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            
            
            guard let gridCellRegis = self.gridCellRegistration else {
                return UICollectionViewCell()
            }
            
            return collectionView.dequeueConfiguredReusableCell(using: gridCellRegis, for: indexPath, item: itemIdentifier)
        })
    }
    
    private func setUpUI() {
        self.view.backgroundColor = .systemBackground
        self.navSegmentedView.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
        collectionView.dataSource = listDataSource
        
        self.view.addSubview(indicator)
        self.view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            self.collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.collectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.collectionView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.indicator.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            self.indicator.centerYAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerYAnchor)
        ])
    }
    
    private func createListLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(120))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 1)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func createGridLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.9),
            heightDimension: .estimated(300))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(300))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func loadProductListToCollectionView() {
        indicator.startAnimating()
        
        manager.getProductsList(pageNo: 1, itemsPerPage: 30) { list in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(list.products)
            
            self.gridDataSource?.apply(snapshot, animatingDifferences: false)
            self.listDataSource?.apply(snapshot, animatingDifferences: false)
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
        }
    }
}

// MARK: - Obj-C Method
extension ViewController {
    @objc func tappedAddButton() {
        let addProductVC = AddProductViewController()
        navigationController?.pushViewController(addProductVC, animated: true)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
        switch self.navSegmentedView.selectedSegmentIndex {
        case 0:
            let layout = createListLayout()
            guard let listDataSource = listDataSource else {
                return
            }
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.dataSource = listDataSource
            
            
        case 1:
            let layout = createGridLayout()
            guard let gridDataSource = gridDataSource else {
                return
            }
            collectionView.setCollectionViewLayout(layout, animated: true)
            collectionView.dataSource = gridDataSource
        default:
            return
        }
    }
}
