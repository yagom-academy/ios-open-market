//
//  EnrollModifyCollectionViewDataSouce.swift
//  OpenMarket
//
//  Created by tae hoon park on 2021/09/10.
//

import UIKit

class EnrollModifyCollectionViewDataSource: NSObject {
    
}

extension EnrollModifyCollectionViewDataSource: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EnrollModifyPhotoCell.Identifier, for: indexPath) as? EnrollModifyPhotoCell else {
            return UICollectionViewCell()
        }
        return cell
    }
    
}
