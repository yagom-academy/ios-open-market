//
//  CollectionView.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.
//

import UIKit

class CollectionView: UICollectionView {
    static let flowlayout = UICollectionViewFlowLayout()
    static let shared = CollectionView(frame: .zero, collectionViewLayout: CollectionView.flowlayout)
    
    func configureCollectionView(viewController: UIViewController){
        viewController.view.addSubview(self)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        self.backgroundColor = UIColor.white
        self.register(CollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        CollectionView.flowlayout.scrollDirection = .vertical
    }
}
