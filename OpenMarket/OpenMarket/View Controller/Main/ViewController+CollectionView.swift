//
//  ViewController+CollectionView.swift
//  OpenMarket
//
//  Created by 고은 on 2022/01/26.
//

import UIKit

// MARK: Delegate Flow Layout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        collectionViewCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        collectionViewCellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (view.frame.width / 2 - 1) - 13
        let height = width * 1.34
        let size = CGSize(width: width, height: height)
        
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellPedding = CGFloat(5)
        return UIEdgeInsets(top: cellPedding, left: cellPedding, bottom: cellPedding, right: cellPedding)
    }
}

// MARK: Data Source, Delegate
extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        productList?.productsInPage.count ?? 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath)
        
        guard let typeCastedCell = cell as? CollectionViewCell else {
            return cell
        }
        
        guard let productList = productList else {
            return typeCastedCell
        }
        
        typeCastedCell.updateCell(data: productList.productsInPage[indexPath.item])
        
        cell.layer.borderColor = UIColor.systemGray3.cgColor
        cell.layer.borderWidth = 1.5
        cell.layer.cornerRadius = 5
        
        let layout = productCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.estimatedItemSize = .zero
        
        return typeCastedCell
    }
}
