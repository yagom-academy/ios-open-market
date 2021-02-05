//
//  CollectionViewController.swift
//  OpenMarket
//
//  Created by sole on 2021/02/04.
//

import UIKit

class CollectionViewController: UIViewController {
    
    @IBOutlet var collectionView: UICollectionView!
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension CollectionViewController: UICollectionViewDelegate {
    
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let mainViewController = self.parent as? MainViewController else {
            return 0
        }
        return mainViewController.itemsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GridCell", for: indexPath) as? GridCell,
              let mainViewController = self.parent as? MainViewController,
              let item = mainViewController.getItem(indexPath.item) else {
            return UICollectionViewCell()
        }
        cell.tag = indexPath.item
        cell.setContents(with: item)
        return cell
    }
}

extension CollectionViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let row = indexPaths.last?.item,
              let mainViewController = self.parent as? MainViewController else {
            return
        }
        if row >= mainViewController.itemsCount - 2 {
            page += 1
            mainViewController.requestItems(page: page) {
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
        }
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let margin: CGFloat = 9
        let itemSpacing: CGFloat = 9
        
        let width = (collectionView.bounds.width - margin * 2 - itemSpacing) / 2
        let height = width * 11 / 7
        
        return CGSize(width: width , height: height)
    }
}
