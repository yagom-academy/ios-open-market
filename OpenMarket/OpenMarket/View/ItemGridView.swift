//
//  ItemGridViewController.swift
//  OpenMarket
//
//  Created by Yeon on 2021/02/01.
//

import Foundation
import UIKit

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.itemArray.count > 0 {
            return self.itemArray.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCollectionViewCell", for: indexPath) as? ItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let item = itemArray[indexPath.row] else {
            return cell
        }
        cell.layer.borderWidth = 2.0
        cell.layer.borderColor = UIColor.systemGray2.cgColor
        cell.layer.cornerRadius = 10.0
        cell.setUpView(with: item)
        
        if let imageURL = item.thumbnails.first {
            DispatchQueue.main.async {
                if let index: IndexPath = collectionView.indexPath(for: cell){
                    if index.item == indexPath.item {
                        cell.itemImageView.setImageFromServer(with: imageURL)
                    }
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension ViewController:  UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        let numberOfItemsPerRow: CGFloat = 2
        let interSpacing: CGFloat = 10
        let totalSpacing = numberOfItemsPerRow * interSpacing
        let itemWidth = (screenWidth - totalSpacing) / numberOfItemsPerRow
        return CGSize(width: itemWidth, height: itemWidth * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}

