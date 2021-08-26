//
//  MainCollectionViewDataSource.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainDataSource: NSObject, UICollectionViewDataSource {
    private let cellIdentifier = "cell"
    private var itemList = [GoodsList]()
    private var itemCount = 0
    
    
    func collectionView(_ collectionView: UICollectionView, reloadWith data: GoodsList){
        itemList.append(data)
        
        itemCount = itemList.reduce(0) { amount, list in
            return amount + list.items.count
        }
        
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MainCell else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: itemList[indexPath.section][indexPath.item])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
}
