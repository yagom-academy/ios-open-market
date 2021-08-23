//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © Jost, 잼킹. All rights reserved.
// 

import UIKit

class ItemListViewController: UIViewController {
    private let apiClient = ApiClient()
    private let imageDownloadManager = ImageDownloadManager()
    private var itemList: [MarketPageItem] = []
    private var nextPage = 1
    private let preloadCount = 8
    
    @IBOutlet private weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var marketItemListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        marketItemListCollectionView.prefetchDataSource = self
        fetchItemList()
    }
    
    private func fetchItemList() {
        apiClient.getMarketPageItems(for: nextPage) { result in
            switch result {
            case .success(let marketPageItem):
                if marketPageItem.items.count > 0 {
                    self.itemList += marketPageItem.items
                    self.nextPage = marketPageItem.page + 1
                    
                    DispatchQueue.main.async {
                        self.loadingIndicator.stopAnimating()
                        self.marketItemListCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                self.handleError(error)
            }
        }
    }
    
    private func reloadCollectionView(with indexPath: IndexPath) {
        DispatchQueue.main.async {
            if self.marketItemListCollectionView.indexPathsForVisibleItems.contains(indexPath) == .some(true) {
                self.marketItemListCollectionView.reloadItems(at: [indexPath])
            }
            
            if self.itemList.count - indexPath.item == self.preloadCount {
                self.fetchItemList()
            }
        }
    }
    
    private func handleError(_ error: Error) {
        if let apiError = error as? ApiError {
            print(apiError)
        }
        if let parsingError = error as? ParsingError {
            print(parsingError)
        }
    }
    
    private func updateImageLabel(on cell: ItemCollectionViewCell, for indexPath: IndexPath) {
        let marketItem = itemList[indexPath.item]
        
        if let image = ImageCacheManager.shared.loadCachedData(for: marketItem.thumbnails[0]) {
            cell.updateThumbnail(to: image)
        }
        else {
            cell.updateThumbnail(to: nil)
            imageDownloadManager.downloadImage(at: indexPath.item, with: marketItem.thumbnails[0], completion: reloadCollectionView(with:))
        }
    }
}

// MARK:- UICollectionViewDelegateFlowLayout
extension ItemListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        let minimumLineSpacing = CGFloat(10)
        return minimumLineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let minimumInterItemSpacing = CGFloat(10)
        return minimumInterItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let commonSectionInset = CGFloat(10)
        let edgeInsets = UIEdgeInsets(top: commonSectionInset,
                                      left: commonSectionInset,
                                      bottom: commonSectionInset,
                                      right: commonSectionInset)
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let minimumInteritemSpacing = CGFloat(10)
        let commonSectionInset = CGFloat(10)
        let numberOfCardPerRow = CGFloat(2)
        let itemCardWidth = (view.frame.width - (commonSectionInset * 2 + minimumInteritemSpacing)) / numberOfCardPerRow
        
        let itemSize = CGSize(width: itemCardWidth, height: getItemCardHeight(with: itemCardWidth))
        return itemSize
    }
    
    private func getItemCardHeight(with width: CGFloat) -> CGFloat {
        return (width / 3) * 5
    }
}

// MARK:- UICollectionViewDataSource
extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "cardItemCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier,
                                                            for: indexPath) as? ItemCollectionViewCell
        else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: itemList[indexPath.item])
        updateImageLabel(on: cell, for: indexPath)
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate
extension ItemListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if let cell = cell as? ItemCollectionViewCell {
            updateImageLabel(on: cell, for: indexPath)
        }
    }
}

// MARK:- UICollectionViewDataSourcePrefetching
extension ItemListViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let marketItem = itemList[indexPath.item]
            imageDownloadManager.downloadImage(at: indexPath.item,
                                               with: marketItem.thumbnails[0],
                                               completion: reloadCollectionView(with:))
        }
    }
}

