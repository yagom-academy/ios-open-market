////
////  OpenMarket - ViewController.swift
////  Created by yagom. 
////  Copyright © yagom. All rights reserved.
//// 
//
//import UIKit
//
//class ProductPageViewController: UIViewController {
//    
//    var collectionView: UICollectionView!
//    @IBOutlet var segmentedControl: UISegmentedControl!
//    @IBOutlet weak var loadIndicatorView: UIActivityIndicatorView!
//    
//    
//    let listCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createListLayout())
//    let gridCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createGridLayout())
//    
////    var dataSource: UICollectionViewDiffableDataSource<Int, Product>?
//    lazy var gridDataSource: UICollectionViewDiffableDataSource<Int, Product> = {
//        return UICollectionViewDiffableDataSource<Int, Product>(collectionView: gridCollectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
//            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: identifier)
//        }
//    }()
//    lazy var listDataSource: UICollectionViewDiffableDataSource<Int, Product> = {
//        return UICollectionViewDiffableDataSource<Int, Product>(collectionView: listCollectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
//            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: identifier)
//        }
//    }()
//    lazy var cellRegistration = UICollectionView.CellRegistration<GridLayoutCell, Product> { (cell, indexPath, identifier) in
//        
////        cell.delegate = self
//        cell.configureContents(imageURL: identifier.thumbnail,
//                               productName: identifier.name,
//                               price: identifier.price.description,
//                               discountedPrice: identifier.discountedPrice.description,
//                               currency: identifier.currency,
//                               stock: String(identifier.stock))
//        
//        cell.layer.borderWidth = 1
//        cell.layer.borderColor = UIColor.systemGray.cgColor
//        cell.layer.cornerRadius = 10
//        cell.layer.masksToBounds = true
//    }
//    var currentPage: Int = 1
//    var itemsPerPage: Int = 10
//    var page: Page?
//    var pages: [Product] = [] {
//        didSet {
//            var snapShot = NSDiffableDataSourceSnapshot<Int, Product>()
//            snapShot.appendSections([0])
//            snapShot.appendItems(pages)
//            isGridLayout ? self.gridDataSource.apply(snapShot) : self.listDataSource.apply(snapShot)
////            self.dataSource?.apply(snapShot)
//        }
//    }
//    var refControl = UIRefreshControl()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        
//        configureViewLayout()
//        
//        collectionView.isSpringLoaded = true
//        
//        refControl.addTarget(self, action: #selector(refreshDidActivate), for: .valueChanged)
//        refControl.attributedTitle = NSAttributedString(string: "상품 로드중!")
//        collectionView.refreshControl = refControl
//        collectionView.addSubview(refControl)
//        refControl.translatesAutoresizingMaskIntoConstraints = false
////        configureDatasource()
//        fetchPage()
//        segmentedControl.selectedSegmentIndex = 1
//        loadIndicatorView.stopAnimating()
//    }
//    
//    func configureViewLayout() {
//        if let collectionView = collectionView {
//            collectionView.removeFromSuperview()
//        }
//        
//        switch isGridLayout {
//        case true:
//            collectionView = gridCollectionView
//        case false:
//            collectionView = listCollectionView
//        }
//        
//        collectionView.delegate = self
////        configureDatasource()
//        view.addSubview(collectionView)
//        collectionView.backgroundColor = .systemBackground
//        collectionView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
//            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)
//        ])
//    }
//    
//    @objc
//    func refreshDidActivate() {
//        itemsPerPage = 10
//        fetchPage()
//        DispatchQueue.global().async {
//            Thread.sleep(forTimeInterval: 2)
//            DispatchQueue.main.async {
//                self.refControl.endRefreshing()
//            }
//        }
//    }
//    
//    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
//        
//        isGridLayout.toggle()
//        collectionView.isHidden = true
//        
//        configureViewLayout()
//        
//        view.bringSubviewToFront(loadIndicatorView)
//        loadIndicatorView.isHidden = false
//        loadIndicatorView.startAnimating()
//
//        DispatchQueue.global().async {
//            Thread.sleep(forTimeInterval: 1)
//            DispatchQueue.main.async {
//                self.loadIndicatorView.stopAnimating()
//                self.collectionView.isHidden = false
//            }
//        }
//        sender.selectedSegmentIndex == 0 ?
//        collectionView.setCollectionViewLayout(ProductPageViewController.createListLayout(), animated: false)
//        : collectionView.setCollectionViewLayout(ProductPageViewController.createGridLayout(), animated: false)
//        collectionView.reloadData()
//        fetchPage()
//    }
//    
//}
//
//extension ProductPageViewController: UICollectionViewDelegate {
//    
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let endPoint = CGPoint(x: 0, y: scrollView.contentSize.height)
//        if targetContentOffset.pointee.y + scrollView.frame.height >= endPoint.y {
//            guard let value = page?.hasNext, value else { return }
//            
//            itemsPerPage += 10
//            fetchPage()
//        }
//    }
//    
//}
//
//extension ProductPageViewController {
//    private static func createGridLayout() -> UICollectionViewLayout {
//        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
//                                              heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
//        
//        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
//                                               heightDimension: .fractionalHeight(0.3225))
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
//                                                       subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        return layout
//    }
//    
//    private static func createListLayout() -> UICollectionViewLayout {
//        let config = UICollectionLayoutListConfiguration(appearance: .plain)
//        return UICollectionViewCompositionalLayout.list(using: config)
//    }
////
////    private func configureDatasource() {
////        dataSource = UICollectionViewDiffableDataSource<Int, Product>(collectionView: collectionView) { (collectionView, indexPath, identifier) -> UICollectionViewCell? in
////            return collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: identifier)
////        }
////    }
//    
//    private func fetchPage() {
//        URLSessionProvider(session: URLSession.shared)
//            .request(.showProductPage(pageNumber: String(currentPage), itemsPerPage: String(itemsPerPage))) { (result: Result<ShowProductPageResponse, URLSessionProviderError>) in
//                switch result {
//                case .success(let data):
//                    self.page = data
//                    self.pages = data.pages
//                    
//                case .failure(let error):
//                    print(error)
//                }
//            }
//    }
//    
//}
