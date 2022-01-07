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
    
    private var listFlowlayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing = 0
        return flowLayout
    }
    
    private var gridFlowlayout: UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.init(top: 10, left: 5, bottom: 10, right: 5)
        self.collectionView.collectionViewLayout = flowLayout
        return flowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        registerXib()
        setUpFlowLayout()
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    private func registerXib() {
        let gridNibName = UINib(nibName: "GridCollectionViewCell", bundle: .main)
        collectionView.register(gridNibName, forCellWithReuseIdentifier: "GridView")
        
        let listNibName = UINib(nibName: "ListCollectionViewCell", bundle: .main)
        collectionView.register(listNibName, forCellWithReuseIdentifier: "ListView")
    }
    
    private func setUpFlowLayout() {
        self.collectionView.collectionViewLayout = listFlowlayout
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
//        guard let cell = collectionView.dequeueReusableCell(
//            withReuseIdentifier: "GridView", for: indexPath
//        ) as? GridCollectionViewCell else {
//            fatalError()
//        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "ListView", for: indexPath
        ) as? ListCollectionViewCell else {
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
//        let halfWidth = UIScreen.main.bounds.width / 2
        let halfWidth = UIScreen.main.bounds.width

        return CGSize(width: halfWidth, height: halfWidth * 0.16)
    }
}
