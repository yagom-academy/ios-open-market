//
//  MainFrameLayout.swift
//  OpenMarket
//
//  Created by kjs on 2021/08/26.
//

import UIKit

class MainDelegate: NSObject, UICollectionViewDelegate {
    
}

extension MainDelegate: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 155, height: 100)
    }
}
