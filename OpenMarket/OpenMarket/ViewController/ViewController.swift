//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class CollectionViewController: UIViewController {
    let segmentedControl = SegmentedControl.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.titleView = segmentedControl
        view.backgroundColor = .white
        
        CollectionView.shared.dataSource = self
        CollectionView.shared.delegate = self
        
        CollectionView.shared.configureCollectionView(viewController: self)
    }
}

extension CollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.backgroundColor = .black
        
        return cell
    }
}

extension CollectionViewController: UICollectionViewDelegate {}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellPadding: CGFloat = 5
        var cellsPerRow: CGFloat = 2
        let imageRatio: CGFloat = 0.5
        
        let widthMinusPadding = UIScreen.main.bounds.width - ( cellPadding + cellPadding * cellsPerRow )
        let eachSide = widthMinusPadding / cellsPerRow
        return CGSize(width: eachSide, height: eachSide / imageRatio)
    }
}

