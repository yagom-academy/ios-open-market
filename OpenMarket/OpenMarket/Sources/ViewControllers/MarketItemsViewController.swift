//
//  OpenMarket - MarketItemsViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class MarketItemsViewController: UIViewController {
    private lazy var layoutSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["LIST", "GRID"])
        segmentedControl.selectedSegmentIndex = LayoutMode.list.rawValue
        segmentedControl.addTarget(self, action: #selector(toggleLayoutMode), for: .valueChanged)
        return segmentedControl
    }()

    private lazy var collectionView: UICollectionView = {
        var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.register(ItemCell.self, forCellWithReuseIdentifier: ItemCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        return collectionView
    }()

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.frame
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(collectionView)
        navigationItem.titleView = layoutSegmentedControl
    }

    @objc private func toggleLayoutMode() {
        LayoutMode.toggle()
        collectionView.reloadData()
    }

}

extension MarketItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemCell = collectionView.dequeueReusableCell(withReuseIdentifier: ItemCell.reuseIdentifier,
                                                            for: indexPath) as? ItemCell else {
            return ItemCell()
        }

        return itemCell
    }
}

extension MarketItemsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 70)
    }
}

enum LayoutMode: Int {
    static var current: LayoutMode = .list
    case list = 0
    case grid = 1

    static func toggle() {
        switch current {
        case .list: current = .grid
        case .grid: current = .list
        }
    }
}
