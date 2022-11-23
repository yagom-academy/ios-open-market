//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    lazy var navSegmentedView: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])

        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemBlue
        return segmentedControl
    }()
    
    enum Section {
        case main
    }
    
    var collectionView: UICollectionView!
    var datasource: UICollectionViewDiffableDataSource<Section, Product>!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createCollectionView()
        configure()
        
        let cellRegistration = UICollectionView.CellRegistration<ListCell, Product> { cell, indexPath, itemIdentifier in
            DispatchQueue.global().async {
                
                if itemIdentifier.hashValue != indexPath.hashValue {
                    let picture = UIImage(data: try! Data(contentsOf: URL(string: itemIdentifier.thumbnail)!))
                     
                    DispatchQueue.main.async {
                        cell.productName.text = "\(itemIdentifier.name)"
                        cell.bargainPrice.text = "\(itemIdentifier.bargainPrice)"
                        cell.stock.text = "\(itemIdentifier.stock)"
                        cell.image.image = picture
                        
                        if itemIdentifier.bargainPrice != itemIdentifier.price {
                            let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: " ")
                            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSRange(location: 0, length: attributeString.length))
                            cell.price.attributedText = attributeString
                            cell.price.text = "\(itemIdentifier.price)"
                        } else {
                            cell.price.isHidden = true
                        }
                        
                    }
                }
            }
        }
        
        datasource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
        })
        
        let manager = NetworkManager()
        
        manager.getProductsList(pageNo: 1, itemsPerPage: 30) { list in
            var snapshot = NSDiffableDataSourceSnapshot<Section, Product>()
            snapshot.appendSections([.main])
            snapshot.appendItems(list.products)
            self.datasource.apply(snapshot, animatingDifferences: true)
        }
        
        setupNavBar()
    }
    
    private func createCollectionView() {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex: Int,
            layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection in
            let contentSize = layoutEnvironment.container.effectiveContentSize
            let columns = 1
            let spacing = CGFloat(10)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                  heightDimension: .estimated(100))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                   heightDimension: .estimated(100))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: columns)
            group.interItemSpacing = .fixed(spacing)
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = spacing
            section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)
            
            return section
        }
        
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
    
    @objc func tappedAddButton() {
        
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl) {
    }
}

