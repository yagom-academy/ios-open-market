//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ItemListViewController: UIViewController {
    private let apiClient = ApiClient()
    private var itemList: [MarketPageItem] = []
    private var nextPage = 1
    private var isFeching = false
    
    @IBOutlet weak var marketItemListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designLayout()
        fetchItemList()
    }
    
    func fetchItemList() {
        guard !isFeching else {
            return
        }
        
        isFeching = true
        apiClient.getMarketPageItems(for: nextPage) { result in
            switch result {
            case .success(let marketPageItem):
                if marketPageItem.items.count > 0 {
                    self.itemList += marketPageItem.items
                    self.nextPage = marketPageItem.page + 1
                    DispatchQueue.main.async {
                        self.marketItemListCollectionView.reloadData()
                    }
                }
            case .failure(let error):
                if let apiError = error as? ApiError {
                    print(apiError)
                }
                if let parsingError = error as? ParsingError {
                    print(parsingError)
                }
            }
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5) {
                self.isFeching = false
            }
        }
    }
    
    private func getItemCardHeight(with width: CGFloat) -> CGFloat {
        return (width / 3) * 5
    }
    
    private func designLayout() {
        let minimumInteritemSpacing = CGFloat(10)
        let minimumLineSpacing = CGFloat(10)
        let commonSectionInset = CGFloat(10)
        let numberOfCardPerRow = CGFloat(2)
        
        let itemCardWidth = (view.frame.width - (commonSectionInset * 2 + minimumInteritemSpacing)) / numberOfCardPerRow
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemCardWidth, height: getItemCardHeight(with: itemCardWidth))
        layout.minimumInteritemSpacing = minimumInteritemSpacing
        layout.minimumLineSpacing = minimumLineSpacing
        layout.sectionInset = UIEdgeInsets(top: commonSectionInset,
                                           left: commonSectionInset,
                                           bottom: commonSectionInset,
                                           right: commonSectionInset)
        
        marketItemListCollectionView.collectionViewLayout = layout
    }
}

extension ItemListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellIdentifier = "cardItemCell"
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let marketItem = itemList[indexPath.item]
        cell.configure(with: marketItem)
        
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.lightGray.cgColor
        cell.layer.cornerRadius = 8
        
        return cell
    }
}

extension ItemListViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard !isFeching else {
            return
        }
        
        let position = scrollView.contentOffset.y
        if position > (marketItemListCollectionView.contentSize.height - scrollView.frame.height) {
            fetchItemList()
        }
    }
}
