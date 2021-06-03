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
        collectionView.register(OpenMarketCollectionViewCell.self, forCellWithReuseIdentifier: OpenMarketCollectionViewCell.identifier)
        collectionView.backgroundColor = .white
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionViewConstraint()
    }
    
    private func setUpCollectionViewConstraint() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(openMarkekCollectionView)
        
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

//        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: width, height: height)
        return layout
    }
}
extension OpenMarketViewController: UICollectionViewDelegate {
    
}
extension OpenMarketViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: OpenMarketCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OpenMarketCollectionViewCell", for: indexPath) as? OpenMarketCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}
extension OpenMarketViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = collectionView.frame.width
        let cellHeight = collectionView.frame.height / 10
        return CGSize(width: cellWidth, height: cellHeight)
    }
}
