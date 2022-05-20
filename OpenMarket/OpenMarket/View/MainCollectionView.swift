//
//  MainCollectionView.swift
//  OpenMarket
//
//  Created by 우롱차, Donnie on 2022/05/20.
//

import UIKit

final class MainCollectionView: UICollectionView {
    
    func changeLayout(viewType: ViewType) {
        switch viewType {
        case .list:
                let configuration = UICollectionLayoutListConfiguration(appearance: .plain)
                let layout = UICollectionViewCompositionalLayout.list(using: configuration)
                setCollectionViewLayout(layout, animated: true)
            
        case .grid:
                let flowLayout = UICollectionViewFlowLayout()
                let inset: CGFloat = 20
                let rowItems = 2
                flowLayout.minimumLineSpacing = inset
                flowLayout.minimumInteritemSpacing = inset
                flowLayout.scrollDirection = .vertical
                flowLayout.itemSize = CGSize(
                    width: (safeAreaLayoutGuide.layoutFrame.width / CGFloat(rowItems)) - (inset * 1.5),
                    height: safeAreaLayoutGuide.layoutFrame.height / 2.5 - inset
                )
                flowLayout.sectionInset.left = inset
                flowLayout.sectionInset.right = inset
                setCollectionViewLayout(flowLayout, animated: true)
        }
    }
}
