//
//  OpenMarket - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class OpenMarketViewController: UIViewController {
    
    lazy private var openMarkekCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setUpCollectionViewLayout())
        collectionView.register(OpenMarketListCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketListCollectionViewCell.identifier)
        collectionView.register(OpenMarketGridCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketGridCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var segmentedController: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.sizeToFit()
        if #available(iOS 13.0, *) {
            segmentedControl.selectedSegmentTintColor = .gray
        } else {
            segmentedControl.tintColor = .white
        }
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpCollectionViewConstraint()
    }
    
    private func setUpCollectionView() {
        self.view.addSubview(openMarkekCollectionView)
        self.navigationItem.titleView = segmentedController
    }
    
    private func setUpCollectionViewConstraint() {
        self.view.backgroundColor = .white

        let margins = view.safeAreaLayoutGuide
        openMarkekCollectionView.leadingAnchor.constraint(equalTo: margins.leadingAnchor).isActive = true
        openMarkekCollectionView.trailingAnchor.constraint(equalTo: margins.trailingAnchor).isActive = true
        openMarkekCollectionView.topAnchor.constraint(equalTo: margins.topAnchor).isActive = true
        openMarkekCollectionView.bottomAnchor.constraint(equalTo: margins.bottomAnchor).isActive = true
    }
    
    private func setUpCollectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let width = (UIScreen.main.bounds.width)
        let height = (UIScreen.main.bounds.height)

        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
}
extension OpenMarketViewController {
    
    // MARK: -Segmented Control
    
}
extension OpenMarketViewController: UICollectionViewDelegate {
    
}
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: OpenMarketGridCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketGridCollectionViewCell", for: indexPath) as? OpenMarketGridCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.bounds.width / 2
        let cellHeight = collectionView.bounds.height / 3
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
