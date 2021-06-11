//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CollectionViewController: UIViewController {
    let segmentedControl = SegmentedControl.shared
    let collectionView = CollectionView(frame: .zero, flowlayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = segmentedControl
        self.view.backgroundColor = .white

        collectionView.dataSource = self
        collectionView.delegate = self

        collectionView.configureCollectionView(viewController: self)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(CollectionViewCellForList.self, forCellWithReuseIdentifier: CollectionViewCellForList.identifier)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCellForList.identifier, for: indexPath)
        
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        var widthSize = ((view.frame.width - 20) / 2)
//
//        if widthSize > 200 {
//            widthSize = 160
//        }

        let widthSize = view.frame.width - 10
        return CGSize(width: widthSize, height: widthSize * 0.25)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
