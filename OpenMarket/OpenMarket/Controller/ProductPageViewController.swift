//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductPageViewController: UIViewController, LayoutSwitchable {
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet weak var loadIndicatorView: UIActivityIndicatorView!
    
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
    
    var isGridLayout: Bool = true
    
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
        loadIndicatorView.stopAnimating()
    }
    
    @objc
    func refreshDidActivate() {
        itemsPerPage = 10
        fetchPage()
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            DispatchQueue.main.async {
                self.refControl.endRefreshing()
            }
        }
    }
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        
        isGridLayout.toggle()
        
        view.bringSubviewToFront(loadIndicatorView)
        loadIndicatorView.isHidden = false
        loadIndicatorView.startAnimating()
        collectionView.isHidden = true

        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 1)
            DispatchQueue.main.async {
                self.loadIndicatorView.stopAnimating()
                self.collectionView.isHidden = false
            }
        }
        sender.selectedSegmentIndex == 0 ?
            collectionView.setCollectionViewLayout(createListLayout(), animated: false)
            : collectionView.setCollectionViewLayout(createLayout(), animated: false)
        collectionView.reloadData()
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
            
            cell.delegate = self
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
        
        dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
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
