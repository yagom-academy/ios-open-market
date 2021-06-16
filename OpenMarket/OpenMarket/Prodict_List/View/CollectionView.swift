//
//  CollectionView.swift
//  OpenMarket
//
//  Created by 김찬우 on 2021/06/09.

import UIKit

class CollectionView: UICollectionView {
    let flowlayout: UICollectionViewFlowLayout

    init(frame: CGRect, flowlayout: UICollectionViewFlowLayout) {
        self.flowlayout = flowlayout
        super.init(frame: frame, collectionViewLayout: flowlayout)

        self.register(CollectionViewCellForList.self, forCellWithReuseIdentifier: CollectionViewCellForList.identifier)
        self.register(CollectionViewCellForGrid.self, forCellWithReuseIdentifier: CollectionViewCellForGrid.identifier)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(viewController: UIViewController) {
        viewController.view.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = .systemBackground
        self.flowlayout.scrollDirection = .vertical
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.topAnchor),
            self.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
            self.leadingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.leadingAnchor),
            self.trailingAnchor.constraint(equalTo: viewController.view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
}
