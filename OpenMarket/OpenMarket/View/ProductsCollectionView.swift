//
//  ProductsCollectionView.swift
//  OpenMarket
//
//  Created by 이호영 on 2022/01/11.
//

import UIKit

class ProductsCollectionView: UICollectionView {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        registerXib()
        self.collectionViewLayout = setUpLayout()
        isHidden = true
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
    }
    
    private func registerXib() {
        let gridNibName = UINib(nibName: ProductCell.listNibName, bundle: .main)
        register(gridNibName, forCellWithReuseIdentifier: ProductCell.listIdentifier)
        
        let listNibName = UINib(nibName: ProductCell.gridNibName, bundle: .main)
        register(listNibName, forCellWithReuseIdentifier: ProductCell.gridIdentifier)
    }
    
    private func setUpLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = listItemSize
        flowLayout.sectionInset = listSectionInset
        flowLayout.minimumLineSpacing = listMinimumLineSpacing
        flowLayout.minimumInteritemSpacing = listminimumInteritemSpacing
        return flowLayout
    }
}

extension ProductsCollectionView {
    func cellSize(numberOFItemsRowAt: CellStyle) -> CGSize {
        switch numberOFItemsRowAt {
        case .portraitList:
            return listItemSize
        case .portraitGrid:
           return portraitGridItemSize
        case .landscapeGrid:
            return landscapeGridItemSize
        }
    }
    
    var listSectionInset: UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    var gridSectionInset: UIEdgeInsets {
        let spacing = ((screenWidth) - (portraitGridItemSize.width * 2)) / 3
        return UIEdgeInsets.init(top: 10, left: spacing, bottom: 10, right: spacing)
    }
    
    var listMinimumLineSpacing: CGFloat {
        return 0
    }
    
    var gridMinimumLineSpacing: CGFloat {
        let spacing = ((screenWidth) - (portraitGridItemSize.width * 2)) / 3
        return spacing
    }
    
    var listminimumInteritemSpacing: CGFloat {
        return 0
    }
    
    var gridminimumInteritemSpacing: CGFloat {
        return 0
    }
    
    private var screenWidth: CGFloat {
        return self.safeAreaLayoutGuide.layoutFrame.width
    }
    
    private var listItemSize: CGSize {
        return CGSize(width: screenWidth,
                      height: screenWidth * 0.155)
    }
    
    private var portraitGridItemSize: CGSize {
        return CGSize(width: (screenWidth / 2) * 0.93,
                      height: (screenWidth / 2) * 1.32)
    }
    
    private var landscapeGridItemSize: CGSize {
        return CGSize(width: screenWidth / 5,
                      height: (screenWidth / 3))
    }
}

enum CellStyle {
    case portraitList
    case portraitGrid
    case landscapeGrid
}
