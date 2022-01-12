//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductPageViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, Product>?
    
    var currentPage: Int = 1
    var itemsPerPage: Int = 10
    var page: Page?
    var pages: [Product] = [] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Int, Product>()
            snapShot.appendSections([0])
            snapShot.appendItems(pages)
            self.dataSource?.apply(snapShot)
        }
    }
    var refControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.isSpringLoaded = true
        collectionView.delegate = self
        
        refControl.addTarget(self, action: #selector(refreshDidActivate), for: .valueChanged)
        refControl.attributedTitle = NSAttributedString(string: "상품 로드중!")
        collectionView.refreshControl = refControl
        collectionView.addSubview(refControl)
        refControl.translatesAutoresizingMaskIntoConstraints = false
        configureDatasource()
        fetchPage()
        segmentedControl.selectedSegmentIndex = 1
    }
    
    @objc
    func refreshDidActivate() {
        itemsPerPage = 10
        fetchPage()
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1.5)
            DispatchQueue.main.async {
                self.refControl.endRefreshing()
            }
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            collectionView.setCollectionViewLayout(createListLayout(), animated: false)
        default:
            collectionView.setCollectionViewLayout(createLayout(), animated: false)
        }
        
        fetchPage()
        
    }
    
}

extension ProductPageViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let endPoint = CGPoint(x: 0, y: scrollView.contentSize.height)
        if targetContentOffset.pointee.y + scrollView.frame.height >= endPoint.y {
            guard let value = page?.hasNext, value else { return }
            
            itemsPerPage += 10
            fetchPage()
        }
    }
    
}

extension ProductPageViewController {
    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3225))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    private func createListLayout() -> UICollectionViewLayout {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        return UICollectionViewCompositionalLayout.list(using: config)
    }
    
    private func configureDatasource() {
        let cellRegistration = UICollectionView.CellRegistration<GridLayoutCell, Product> { (cell, indexPath, identifier) in
            
            cell.configureContents(imageURL: identifier.thumbnail,
                                   productName: identifier.name,
                                   price: identifier.price.description,
                                   discountedPrice: identifier.discountedPrice.description,
                                   currency: identifier.currency,
                                   stock: String(identifier.stock))
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.systemGray.cgColor
            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            
        }
        
        let listCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Product> { (cell, indexPath, item) in
            
            var content = UIListContentConfiguration.subtitleCell()
            
            content.text = item.name
            content.secondaryText = item.price.description
            
            if item.discountedPrice == 0  {
                
                content.secondaryText = "\(item.currency) \(item.price)"
                
            } else {
                
                let attributeString = NSMutableAttributedString(string: "\(item.currency) \(item.discountedPrice)")
                attributeString.addAttribute(
                    NSAttributedString.Key.strikethroughStyle,
                    value: 2,
                    range: NSMakeRange(0, attributeString.length)
                )
                
                let twoAttributeString = NSMutableAttributedString(string: " \(item.currency) \(item.price)")
                
                attributeString.append(twoAttributeString)
                
                content.secondaryAttributedText = attributeString
                
                
            }
            
            content.image = UIImage(named: "Image")!
            
            URLSessionProvider(session: URLSession.shared).requestImage(from: item.thumbnail) { result in
                
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        content.image = data
                        cell.contentConfiguration = content
                    case .failure:
                        content.image = UIImage(named: "Image")!
                        cell.contentConfiguration = content
                    }
                }
            }
            
        }
        
        dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            
            switch self.segmentedControl.selectedSegmentIndex {
            case 1:
                return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
            default:
                return collectionView.dequeueConfiguredReusableCell(using: listCellRegistration, for: indexPath, item: identifier)
            }
        }
    }
    
    private func fetchPage() {
        URLSessionProvider(session: URLSession.shared)
            .request(.showProductPage(pageNumber: String(currentPage), itemsPerPage: String(itemsPerPage))) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
                switch result {
                case .success(let data):
                    self.page = data
                    self.pages = data.pages
                    
                case .failure(let error):
                    print(error)
                }
            }
    }
    
}
