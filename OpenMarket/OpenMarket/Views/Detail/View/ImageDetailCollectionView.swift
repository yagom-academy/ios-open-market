//
//  ImageDetailCollectionView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/25.
//

import UIKit

class ImageDetailCollectionView: UICollectionView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerXib()
        setUpCollectionView()
        isPagingEnabled = true
        showsHorizontalScrollIndicator = false
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: ImageViewCell.nibName, bundle: .main)
        register(nibName, forCellWithReuseIdentifier: ImageViewCell.identifier)
    }
    
    private func setUpCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        collectionViewLayout = flowLayout
    }
}
