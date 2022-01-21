//
//  ImagedCollectionView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/19.
//

import UIKit

class ImagesCollectionView: UICollectionView {

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerXib()
        setUpLayout()
    }

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    private func registerXib() {
        let cellNib = UINib(nibName: ImageCell.nibName, bundle: .main)
        register(
            cellNib,
            forCellWithReuseIdentifier: ImageCell.identifier
        )
        
        let headerNib = UINib(nibName: ImageAddHeaderView.nibName, bundle: .main)
        register(
            headerNib,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: ImageAddHeaderView.identifier
        )
    }
    
    private func setUpLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionViewLayout = flowLayout
        showsHorizontalScrollIndicator = false
    }
}
