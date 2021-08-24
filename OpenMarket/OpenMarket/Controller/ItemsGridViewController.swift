//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ItemsGridViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    private let manager = NetworkManager(session: URLSession.shared)
    private var items: [Page.Item]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeItems()
        collectionView.collectionViewLayout = configureItemSize()
    }
    
    private func initializeItems() {
        let serverURL = "https://camp-open-market-2.herokuapp.com/items/6"
        let mockURL = MockURL.mockItems.description
        
        guard let url = URL(string: serverURL) else { return }
        
        manager.fetchData(url: url) { (result: Result<Page, Error>) in
            switch result {
            case .success(let decodedData):
                self.items = decodedData.items
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func configureItemSize() -> UICollectionViewFlowLayout {
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
