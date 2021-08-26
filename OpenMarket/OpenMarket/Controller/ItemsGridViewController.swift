//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ItemsGridViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    
    private let manager = NetworkManager(session: URLSession.shared)
    private var items: [Page.Item]?
    private var isNotLoading = true
    private var lastPage = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeItems()
        collectionView.collectionViewLayout = configureItemSize()
    }
    
    private func initializeItems() {
        let serverURL = "https://camp-open-market-2.herokuapp.com/items/\(lastPage)"
        let mockURL = MockURL.mockItems.description
        
        guard let url = URL(string: serverURL) else { return }
        
        manager.fetchData(url: url) { (result: Result<Page, Error>) in
            switch result {
            case .success(let decodedData):
                self.items = decodedData.items
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.indicator.stopAnimating()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureItemSize() -> UICollectionViewFlowLayout {
        collectionView.layoutIfNeeded()
        
        let layout = UICollectionViewFlowLayout()
        let defaultInset: CGFloat = 8
        let numberOfItemPerRow: CGFloat = 2
        let sizeRatio: CGFloat = 1.7
        
        layout.sectionInset = UIEdgeInsets(top: defaultInset,
                                           left: defaultInset,
                                           bottom: .zero,
                                           right: defaultInset)
        
        let contentWidth = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        
        let cellWidth = (contentWidth - layout.minimumInteritemSpacing) / numberOfItemPerRow
        let cellHeight = cellWidth * sizeRatio
        
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        
        return layout
    }
}

extension ItemsGridViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let gridItemCellID = "gridViewCell"
        guard let item = items?[indexPath.item],
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: gridItemCellID,
                                                            for: indexPath) as? GridItemCollectionViewCell
        else { return UICollectionViewCell() }
        
        cell.initialize(item: item, indexPath: indexPath)
        
        return cell
    }
}

extension ItemsGridViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let itemsCount = items?.count else { return }
        
        if indexPath.row == itemsCount - 4 && isNotLoading {
            loadMoreData(indexPath: indexPath)
        }
    }
    
    private func loadMoreData(indexPath: IndexPath) {
        if isNotLoading {
            isNotLoading = false
            lastPage += 1
            let serverURL = "https://camp-open-market-2.herokuapp.com/items/\(lastPage)"
            
            guard let url = URL(string: serverURL) else { return }
            
            manager.fetchData(url: url) { (result: Result<Page, Error>) in
                switch result {
                case .success(let decodedData):
                    self.items?.append(contentsOf: decodedData.items)
                    DispatchQueue.main.async {
                        self.collectionView.reloadItems(at: [indexPath])
                        self.isNotLoading = true
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
    }
}
