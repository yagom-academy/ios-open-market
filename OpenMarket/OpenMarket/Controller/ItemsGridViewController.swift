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
    }
    
    private func initializeItems() {
        let serverURL = "https://camp-open-market-2.herokuapp.com/items/1"
        
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
        
        cell.updateContents(item: item,
                            indexPath: indexPath)
        
        return cell
    }
}

extension ItemsGridViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let defaultInset: CGFloat = 8
        let numberOfRow: CGFloat = 2
        let sizeRatio: CGFloat = 1.7
        
        guard let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return CGSize.zero
        }
        
        layout.sectionInset = UIEdgeInsets(top: defaultInset,
                                           left: defaultInset,
                                           bottom: .zero,
                                           right: defaultInset)
        
        let numberOfItemPerRow: CGFloat = numberOfRow
        let contentWidth = collectionView.bounds.width - (layout.sectionInset.left + layout.sectionInset.right)
        
        let cellWidth = (contentWidth - layout.minimumInteritemSpacing) / numberOfItemPerRow
        let cellHeight = cellWidth * sizeRatio
        
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
