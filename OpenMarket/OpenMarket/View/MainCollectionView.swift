//
//  MainCollectionView.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/20.
//

import UIKit

final class MainCollectionView: UICollectionView {
    
    private lazy var listLayout: UICollectionViewCompositionalLayout = {
        let configure = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: configure)
        return layout
    }()
    
    private lazy var gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        let inset: CGFloat = 20
        let rowItems = 2
        layout.minimumLineSpacing = inset
        layout.minimumInteritemSpacing = inset
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(
            width: (safeAreaLayoutGuide.layoutFrame.width / CGFloat(rowItems)) - (inset * 1.5),
            height: safeAreaLayoutGuide.layoutFrame.height / 2.5 - inset
        )
        layout.sectionInset.left = inset
        layout.sectionInset.right = inset
        return layout
    }()
    
    func changeLayout(viewType: ViewType) {
        switch viewType {
        case .list:
            setCollectionViewLayout(listLayout, animated: true)
            
        case .grid:
            setCollectionViewLayout(gridLayout, animated: true)
        }
    }
}
