//
//  MainCollectionViewDataSource.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainDataSource: NSObject, UICollectionViewDataSource {
    private let numberFormatter = NumberFormatter()
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
        
        let itemAmountPerList = 20
        let pageIndex = indexPath.item / itemAmountPerList
        let itemIndex = indexPath.item - (pageIndex * itemAmountPerList)
        
        cell.configure(withItem: itemList[pageIndex][itemIndex], formatter: numberFormatter)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemCount
    }
}
