//
//  ProductsCollectionView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/11.
//

import UIKit

class ProductsCollectionView: UICollectionView {

    private var listFlowlayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let width = UIScreen.main.bounds.width
        flowLayout.itemSize = CGSize(width: width, height: width * 0.155)
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }
    
    private var gridFlowlayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.93, height: halfWidth * 1.32)
        let spacing = (UIScreen.main.bounds.width - flowLayout.itemSize.width * 2) / 3
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: spacing, bottom: 10, right: spacing)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = spacing
        self.collectionViewLayout = flowLayout
        return flowLayout
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerXib()
        setUpListFlowLayout()
        isHidden = true
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    func setUpListFlowLayout() {
        self.collectionViewLayout = listFlowlayout
    }
    
    func setUpGridFlowLayout() {
        self.collectionViewLayout = gridFlowlayout
    }
    
    private func registerXib() {
        let gridNibName = UINib(nibName: ProductCell.listNibName, bundle: .main)
        register(gridNibName, forCellWithReuseIdentifier: ProductCell.listIdentifier)
        
        let listNibName = UINib(nibName: ProductCell.gridNibName, bundle: .main)
        register(listNibName, forCellWithReuseIdentifier: ProductCell.gridIdentifier)
    }
}
