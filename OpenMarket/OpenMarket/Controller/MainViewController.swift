//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MainViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var segmentControl: UISegmentedControl! {
        didSet {
            let normal: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.white]
            let selected: [NSAttributedString.Key: Any] = [.foregroundColor: UIColor.black]
            segmentControl.setTitleTextAttributes(normal, for: .normal)
            segmentControl.setTitleTextAttributes(selected, for: .selected)
            segmentControl.selectedSegmentTintColor = .white
            segmentControl.backgroundColor = .black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let gridNibName = UINib(nibName: "GridCollectionViewCell", bundle: .main)
        collectionView.register(gridNibName, forCellWithReuseIdentifier: "GridView")
        setUpFlowLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    }
    
    private func setUpFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 5)
        self.collectionView.collectionViewLayout = flowLayout
    }
}

extension MainViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
    numberOfItemsInSection section: Int) -> Int {

        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView,
      cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "GridView", for: indexPath
        ) as? GridCollectionViewCell else {
            fatalError()
        }

        return cell
    }
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
      layout collectionViewLayout: UICollectionViewLayout,
      sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let halfWidth = UIScreen.main.bounds.width / 2

        return CGSize(width: halfWidth * 0.93, height: halfWidth * 1.32)
    }
}
