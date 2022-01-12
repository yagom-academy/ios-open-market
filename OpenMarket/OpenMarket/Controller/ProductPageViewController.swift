//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ProductPageViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<Int, Product>?
    
    var currentPage: Int = 1
    var itemsPerPage: Int = 20
    var page: Page?
    var pages: [Product] = [] {
        didSet {
            var snapShot = NSDiffableDataSourceSnapshot<Int, Product>()
            snapShot.appendSections([0])
            snapShot.appendItems(pages)
            self.dataSource?.apply(snapShot)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.setCollectionViewLayout(createLayout(), animated: false)
        
        collectionView.delegate = self
        
        configureDatasource()
        fetchPage()
    }

}

extension ProductPageViewController: UICollectionViewDelegate {
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let startPoint = CGPoint(x: 0, y: 0)
        let endPoint = CGPoint(x: 0, y: scrollView.contentSize.height)
        
        if targetContentOffset.pointee.y <= startPoint.y {
            // 이전 페이지 로드
            guard let value = page?.hasPrev, value else { return }
            
            currentPage = max(currentPage - 1, 1)
            fetchPage()
            
        }
        
        if targetContentOffset.pointee.y + scrollView.frame.height >= endPoint.y {
            // 다음 페이지 로드
            guard let value = page?.hasNext, value else { return }
            
            currentPage += 1
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
